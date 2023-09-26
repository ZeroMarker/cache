Class EPRservice.Observer.CustomEPRInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// w ##Class(EPRservice.Observer.CustomEPRInfo).GetCustomInfo("201764","WMRInfection","SAVE|155")
ClassMethod GetCustomInfo(AEpisodeID As %String, AType As %String, ACustomItemCode As %String, AInstanceDataID As %String) As %String
{
	s value = ""
	
	if (AType = "WMRInfection") 
	{
		s value = ..GetWMRInfectionItem(AEpisodeID, ACustomItemCode, AInstanceDataID)
	}
	
	q value
}

/// Desc:	自定义的病案首页诊断信息
/// Return:	itemRowID1_"^"_itemCode1_"^"_itemDesc1_$c(1)_itemRowID2_"^"_itemCode2_"^"_itemDesc2 
ClassMethod GetWMRInfectionItem(AEpisodeID As %String, ACustomItemCode As %String, AInstanceDataID As %String) As %String
{
	//b "s"
	q:(ACustomItemCode="")||(ACustomItemCode = $C(0)) ""
	
	s diagListInfo = ..GetDiagListConfig(ACustomItemCode)
	q:(diagListInfo="")||(diagListInfo=$c(0)) ""
	
	s diagList = $p(diagListInfo, $c(1), 1)
	q:(diagList="")||(diagList=$c(0)) ""
	
	s isRowID = $p(diagListInfo, $c(1), 2)
	
	s retValue = ""
	
	s count = $L(diagList, "^")
	for i = 1:1:count
	{	
		s oneDiag = $P(diagList,"^",i)
		continue:(oneDiag="")||(oneDiag=$c(0))
		
		//b "s"
		if (AInstanceDataID = "")||(AInstanceDataID = $c(0))
		{
			s itemValue = ##Class(EPRservice.BOScatterData).GetEPRData(AEpisodeID,oneDiag)
		}
		else
		{
			s itemValue = ##Class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID,oneDiag,AInstanceDataID)
		}
		
		if (itemValue '= "")&&(itemValue '= "^")
		{
			s itemRowID = "", itemCode = "", itemDesc = ""
			
			if (isRowID = "1")
			{
				s itemRowID = $p(itemValue, "^", 1)
				s:(itemRowID'="") itemCode = $p($g(^MRC("ID",itemRowID)),"^",4)
				s itemDesc = $p(itemValue, "^", 2)
			}
			else
			{
				s itemRowID = ""
				s itemCode = $P(itemValue,"^", 1)
				s itemDesc = $p(itemValue,"^", 2)
			}
			
			if (retValue = "")
			{	s retValue = itemRowID_"^"_itemCode_"^"_itemDesc }
			else
			{	s retValue = retValue_$c(1)_itemRowID_"^"_itemCode_"^"_itemDesc }
		}
	}
	
	q retValue
}

/// Desc:	配置传染病上报需要获取的诊断字典配置
/// 		配置的数据供以下方法使用：GetDiagListConfig()
/// Input：	ADictName : 字典名称，格式：操作项|界面模板ID，
/// 					如 SAVE|154
/// 		ADiagList : 诊断字典取数编码，多个诊断字典之间使用^分割
/// 					如 主要诊断#TYPE:Simple#TID:155#TVER:0#SCODE:I0002#VTYPE:CANDV^其他诊断1#TYPE:Simple#TID:155#TVER:0#SCODE:I0003#VTYPE:CANDV^其他诊断2#TYPE:Simple#TID:155#TVER:0#SCODE:I0009#VTYPE:CANDV
/// 		ADesc	  ：字典描述
/// 		ACodeIsRowID ：诊断字典取数编码取出的字典数据的代码列是否为诊断字典的rowid，值域约定：1或0, 1是rowid，0不是rowid
/// Debug：	w ##Class(EPRservice.Observer.CustomEPRInfo).InitDiagListConfig("SAVE|155","主要诊断#TYPE:Simple#TID:155#TVER:0#SCODE:I0002#VTYPE:CANDV^其他诊断1#TYPE:Simple#TID:155#TVER:0#SCODE:I0003#VTYPE:CANDV^其他诊断2#TYPE:Simple#TID:155#TVER:0#SCODE:I0009#VTYPE:CANDV","0","病案首页界面诊断信息")
ClassMethod InitDiagListConfig(ADictName As %String, ADiagList As %String, ACodeIsRowID As %String, ADesc As %String) As %String
{
	q:(ADictName = "")||(ADiagList="")||(ADesc="") "入参不能为空"
	
	
	&sql(select top 1 ID into :mastID from EPRmeta.CustomDictionary where CtmDictType = 'SubjectWMRDiagList' and CtmDictName= :ADictName and CtmDictStatus='Y')
	if (SQLCODE = 0)
	{
		&sql(update EPRmeta.CustomDictionary set CtmDictCode = :ADiagList, CtmDictDesc = :ADesc, CtmDictComment = :ACodeIsRowID where ID = :mastID) 
	}	
	else
	{
		&sql(insert into EPRmeta.CustomDictionary (CtmDictType, CtmDictStatus, CtmDictName, CtmDictCode, CtmDictDesc, CtmDictComment) values ('SubjectWMRDiagList', 'Y', :ADictName, :ADiagList, :ADesc, :ACodeIsRowID))
	}
	
	q SQLCODE
}

/// Desc:	获取"病案首页"相关文书参数
/// Debug:	w ##Class(EPRservice.Observer.CustomEPRInfo).GetDiagListConfig("SAVE|155")
ClassMethod GetDiagListConfig(ADictName) As %String
{
	k SQLCODE
	
	&sql(select top 1 CtmDictCode, CtmDictComment into :info, :info2 from EPRmeta.CustomDictionary where CtmDictType = 'SubjectWMRDiagList' and CtmDictName= :ADictName and CtmDictStatus='Y')
	
	q:(SQLCODE '= 0) ""
	
	q info_$c(1)_info2
}

/// d ##Class(EPRservice.Observer.CustomEPRInfo).TestInit()
ClassMethod TestInit()
{
	s item = "#TYPE:Simple#TID:155#TVER:0#SCODE:I0002#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0003#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0009#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0010#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0011#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0012#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0013#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0036#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0111#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0112#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0113#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0114#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0119#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0120#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0121#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0122#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0123#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0124#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0125#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0126#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0127#VTYPE:CANDV^#TYPE:Simple#TID:155#TVER:0#SCODE:I0128#VTYPE:CANDV"
	w ##Class(EPRservice.Observer.CustomEPRInfo).InitDiagListConfig("SAVE|155",item,"0", "病案首页界面诊断信息")

	s item = "#TYPE:Simple#TID:32#TVER:0#SCODE:I0001#VTYPE:CANDV^#TYPE:Simple#TID:32#TVER:0#SCODE:I0002#VTYPE:CANDV^#TYPE:Simple#TID:32#TVER:0#SCODE:I0003#VTYPE:CANDV^#TYPE:Simple#TID:32#TVER:0#SCODE:I0004#VTYPE:CANDV^#TYPE:Simple#TID:32#TVER:0#SCODE:I0005#VTYPE:CANDV^#TYPE:Simple#TID:32#TVER:0#SCODE:I0006#VTYPE:CANDV^#TYPE:Simple#TID:32#TVER:0#SCODE:I0007#VTYPE:CANDV^#TYPE:Simple#TID:32#TVER:0#SCODE:I0008#VTYPE:CANDV^#TYPE:Simple#TID:32#TVER:0#SCODE:I0009#VTYPE:CANDV^#TYPE:Simple#TID:32#TVER:0#SCODE:I0010#VTYPE:CANDV"
	w ##Class(EPRservice.Observer.CustomEPRInfo).InitDiagListConfig("SAVE|32",item,"0", "入院记录初步诊断信息")

	s item = "#TYPE:Simple#TID:33#TVER:0#SCODE:I0001#VTYPE:CANDV#TYPE:Simple#TID:33#TVER:0#SCODE:I0001#VTYPE:CANDV^#TYPE:Simple#TID:33#TVER:0#SCODE:I0002#VTYPE:CANDV^#TYPE:Simple#TID:33#TVER:0#SCODE:I0003#VTYPE:CANDV^#TYPE:Simple#TID:33#TVER:0#SCODE:I0004#VTYPE:CANDV^#TYPE:Simple#TID:33#TVER:0#SCODE:I0005#VTYPE:CANDV^#TYPE:Simple#TID:33#TVER:0#SCODE:I0006#VTYPE:CANDV^#TYPE:Simple#TID:33#TVER:0#SCODE:I0007#VTYPE:CANDV^#TYPE:Simple#TID:33#TVER:0#SCODE:I0008#VTYPE:CANDV^#TYPE:Simple#TID:33#TVER:0#SCODE:I0009#VTYPE:CANDV^#TYPE:Simple#TID:33#TVER:0#SCODE:I0010#VTYPE:CANDV"
	w ##Class(EPRservice.Observer.CustomEPRInfo).InitDiagListConfig("SAVE|33",item,"0", "诊断变更记录诊断信息")
}

}

/// 描述：电子病历信息查询业务对象
/// 创建者：houjian
/// 创建日期：2011-06-03
Class EPRservice.BLL.Query.BLEPRInfo Extends %RegisteredObject [ ClassType = "", LegacyInstanceContext, ProcedureBlock ]
{

/// 就诊指针
Property EpisodeID As %String(TRUNCATE = 1);

/// 缓存的InstanceDataID数组，其Key是TemplateID，Value是InstanceDataID
Property InstanceArray As %ArrayOfDataTypes;

/// Desc:	实例化业务逻辑对象
/// Debug:	w ##Class(EPRservice.BLL.Query.BLEPRInfo).CreateInstance()
ClassMethod CreateInstance(AEpisodeID As %String) As EPRservice.BLL.Query.BLEPRInfo
{
	s obj = ##Class(EPRservice.BLL.Query.BLEPRInfo).%New()
	s obj.EpisodeID = AEpisodeID
	s obj.InstanceArray = ##Class(%ArrayOfDataTypes).%New()
	q obj
}

/// Desc:	更新业务逻辑对象对应的就诊指针
Method SetEpisodeID(AEpisodeID As %String) As %Status
{
	s %this.EpisodeID = AEpisodeID
	d %this.InstanceArray.Clear()
	q $$$OK
}

/// Desc:	获取电子病历打撒数据
Method GetEPRData(AItemPara As %String) As %String
{
	set retVal = ""
	s retVal = ..GetItemData(AItemPara)
	s retVal = ..ConvertChar(retVal)
	q retVal
}

/// Desc:	获取电子病历数据
Method GetItemData(AItemPara As %String) As %String
{
	s retVal = ""

	set desc = $p(AItemPara,"#",1)
	set type = $p($p(AItemPara,"#",2),":",2)
	set tid = $p($p(AItemPara,"#",3),":",2)
	
	if (type = "Simple")
	{
		set scode = $p($p(AItemPara,"#",5),":",2)
		set vtype = $p($p(AItemPara,"#",6),":",2)
		s retVal = ..GetSimpleData(tid, scode, vtype)
	}
	elseif (type = "Segment")
	{
		set scode = $p($p(AItemPara,"#",5),":",2)
		set retVal = ..GetSegmentData(tid, scode)
	}
	elseif (type = "SegmentSimple")
	{
		set sgcode = $p($p(AItemPara,"#",5),":",2)
		set scode = $p($p(AItemPara,"#",6),":",2)
		set vtype = $p($p(AItemPara,"#",7),":",2)
		set retVal = ..GetSegmentSimpleData(tid, sgcode, scode, vtype)
	}
	elseif (type = "TextDesc")
	{
		set scode = $p($p(AItemPara,"#",5),":",2)
		set retVal = ..GetTextDescData(tid, scode)
	}
	elseif (type = "TextDescSimple")
	{
		set tdcode = $p($p(AItemPara,"#",5),":",2)
		set scode = $p($p(AItemPara,"#",6),":",2)
		set vtype = $p($p(AItemPara,"#",7),":",2)
		set kbnodeid =  $p($p(AItemPara,"#",8),":",2)
		set kbpartno =  $p($p(AItemPara,"#",9),":",2)
		set retVal = ..GetTDSimpleData(tid, tdcode, scode, kbnodeid, kbpartno, vtype)
	}
	//以下是三版病历打散数据查询
	else
	{
		s retVal = ##Class(EMRservice.BL.BLScatterData).GetScatterData(%this.EpisodeID,AItemPara,"")
	}
	q retVal
}

/// Desc:	获取简单单元数据
Method GetSimpleData(ATid As %String, AScode As %String, AVType As %String) As %String
{
	s data = ""
	
	//取 EPRinstance.InstanceData ID
	s instanceID = ..GetCachedInstanceID(ATid)
	if (instanceID = "")
	{
		s instanceID = $O(^DHCEPRI.ISimpleI("IdxForLink"," "_%this.EpisodeID," "_ATid," "_AScode,""))
		d ..SetCachedInstanceID(instanceID, ATid)
	}
	q:(instanceID = "")||(instanceID = "UnSave") data
	
	//取 EPRinstance.ISimple ID
	s rowid = $O(^DHCEPRI.ISimpleI("IdxForLink"," "_%this.EpisodeID," "_ATid," "_AScode,instanceID,""))
	q:(rowid = "") data
	
	//取 EPRinstance.ISimple 数据
	s obj = ##Class(EPRinstance.ISimple).%OpenId(rowid)
	q:(obj = "") data
    s data = ..GetDataValue(AVType,obj.DataValue,obj.ValueCode)
    q data
}

/// Desc:	获取Segment数据
/// modify: Candyxu 修改读取流操作
Method GetSegmentData(ATid As %String, ASegmentcode As %String) As %String
{
	s data = ""
	//取 EPRinstance.InstanceData ID
	s instanceID = ..GetCachedInstanceID(ATid)
	if (instanceID = "")
	{
		s instanceID = $O(^DHCEPRI.ISegmentI("IdxForLink"," "_%this.EpisodeID," "_ATid," "_ASegmentcode,""))
		d ..SetCachedInstanceID(instanceID, ATid)
	}
	q:(instanceID = "")||(instanceID = "UnSave") data
	
	//取 EPRinstance.ISimple ID
	s rowid = $O(^DHCEPRI.ISegmentI("IdxForLink"," "_%this.EpisodeID," "_ATid," "_ASegmentcode,instanceID,""))
	q:(rowid = "") data
	
	//取 EPRinstance.ISimple 数据
	s obj = ##Class(EPRinstance.ISegment).%OpenId(rowid)
	q:(obj = "") data
	
	//不能直接读取obj.Text的流数据，有时会导致错误，Cache代码bug需要新建一个流对象
	s newObj = ##class(%GlobalCharacterStream).%New()
	d newObj.CopyFrom(obj.Text)
	
	do newObj.Rewind()
	while (newObj.AtEnd = 0) 
  	{ 	
    	set data = data_newObj.Read(10240)
   	}
    d newObj.%Close()
    s obj = ""   	
   	q data
}

/// Desc:	获取SegmentSimple数据
Method GetSegmentSimpleData(ATid As %String, ASegmentCode As %String, ASimpleCode As %String, AVType As %String) As %String
{
	s data = ""
	
	//取 EPRinstance.InstanceData ID
	s instanceID = ..GetCachedInstanceID(ATid)
	if (instanceID = "")
	{
		s instanceID = $O(^DHCEPRI.ISegmentSimpleI("IdxForLink"," "_%this.EpisodeID," "_ATid," "_ASegmentCode," "_ASimpleCode,""))
		d ..SetCachedInstanceID(instanceID, ATid)
	}
	q:(instanceID = "")||(instanceID = "UnSave") data
	
	//取 EPRinstance.ISegmentSimple ID
	s rowid = $O(^DHCEPRI.ISegmentSimpleI("IdxForLink"," "_%this.EpisodeID," "_ATid," "_ASegmentCode," "_ASimpleCode,instanceID,""))
	q:(rowid = "") data
	
	//取 EPRinstance.ISegmentSimple 数据
	s obj = ##Class(EPRinstance.ISegmentSimple).%OpenId(rowid)
	q:(obj = "") data
	s data = ..GetDataValue(AVType,obj.DataValue,obj.ValueCode)
	q data
}

/// Desc:	获取TextDesc数据
/// modify: Candyxu 修改读取流操作
Method GetTextDescData(ATid As %String, ATextDescCode As %String) As %String
{
	s data = ""
	
	//取 EPRinstance.InstanceData ID
	s instanceID = ..GetCachedInstanceID(ATid)
	if (instanceID = "")
	{
		s instanceID = $O(^DHCEPRI.ITextDescI("IdxForLink"," "_%this.EpisodeID," "_ATid," "_ATextDescCode,""))
		d ..SetCachedInstanceID(instanceID, ATid)
	}
	q:(instanceID = "")||(instanceID = "UnSave") data
	
	//取 EPRinstance.ITextDesc ID
	s rowid = $O(^DHCEPRI.ITextDescI("IdxForLink"," "_%this.EpisodeID," "_ATid," "_ATextDescCode,instanceID,""))
	q:(rowid = "") data
	
	//取 EPRinstance.ITextDesc 数据
	s obj = ##Class(EPRinstance.ITextDesc).%OpenId(rowid)
	q:(obj = "") data
	
	//不能直接读取obj.Text的流数据，有时会导致错误，Cache代码bug需要新建一个流对象
	s newObj = ##class(%GlobalCharacterStream).%New()
	d newObj.CopyFrom(obj.Text)
	
	do newObj.Rewind()
	while (newObj.AtEnd = 0) 
  	{ 	
    	set data = data_newObj.Read(10240)
   	}
    d newObj.%Close()
    s obj = ""   	  	
   	q data
}

/// Desc:	获取TextDescSimple数据
Method GetTDSimpleData(ATid As %String, ATDCode As %String, ASCode As %String, AKBNodeID As %String, AKBPartNo As %String, AVType As %String) As %String
{
	s data = ""
	
	//取 EPRinstance.InstanceData ID
	s instanceID = ..GetCachedInstanceID(ATid)
	if (instanceID = "")
	{
		s instanceID = $O(^DHCEPRI.ITextDescSimpleI("IdxForLink", " "_%this.EpisodeID, " "_ATid, " "_ATDCode, " "_AKBNodeID, " "_AKBPartNo, " "_ASCode, ""))
		d ..SetCachedInstanceID(instanceID, ATid)
	}
	q:(instanceID = "")||(instanceID = "UnSave") data

	//取 EPRinstance.ITextDescSimple ID
	s rowid = $O(^DHCEPRI.ITextDescSimpleI("IdxForLink", " "_%this.EpisodeID, " "_ATid, " "_ATDCode, " "_AKBNodeID, " "_AKBPartNo, " "_ASCode, instanceID, ""))
	q:(rowid = "") data
	
	//取 EPRinstance.ITextDescSimple 数据
	s obj = ##Class(EPRinstance.ITextDescSimple).%OpenId(rowid)
	q:(obj = "") data
	s data = ..GetDataValue(AVType,obj.DataValue,obj.ValueCode)
	q data
}

/// Desc:	获取缓存的InstanceDataID
/// Input:	ATemplateID: 界面模板ID
/// Output:	无
/// Return:	"" ： 		未缓存，
/// 		UnSave ：	已缓存，但对应InstanceDataID不存在，
/// 		123||1 : 	已缓存，对应的InstanceDataID值
Method GetCachedInstanceID(ATemplateID As %String) As %String
{
	q %this.InstanceArray.GetAt(ATemplateID)
}

/// Desc:	设置缓存的InstanceDataID
/// Input:	AInstanceDataID ：要缓存的InstanceDataID
/// 		ATemplateID : 界面模板ID
/// Output:	无
/// Return：%Status
Method SetCachedInstanceID(AInstanceDataID As %String, ATemplateID As %String) As %Status
{
	if (AInstanceDataID = "")
	{
		q %this.InstanceArray.SetAt("UnSave", ATemplateID)
	}
	else
	{
		q %this.InstanceArray.SetAt(AInstanceDataID, ATemplateID)
	}
}

/// Desc:返回拆散简单单元值
/// add by Candyxu
/// 20120328
/// reson(增加返回值类型)
Method GetDataValue(AVType As %String, ADataValue As %String, ADataCode As %String) As %String
{
	s data = ""
	if (AVType = "V") {	
	    s data = ADataValue
	}elseif (AVType = "C") {	
		s data = ADataCode
	}elseif (AVType = "VC"){
		s data = ADataValue_ADataCode
	}elseif (AVType = "CV"){
		s data = ADataCode_ADataValue
	}elseif (AVType = "VANDC"){
		s data = ADataValue_"^"_ADataCode
		if (data = "^") {s data = "" }
	}elseif (AVType = "CANDV"){
		s data = ADataCode_"^"_ADataValue
		if (data = "^") {s data = "" }
	}elseif (AVType = "YEAR"){
		s data = $P(ADataCode, "-", 1)
	}elseif (AVType = "MONTH"){
		s data = $P(ADataCode, "-", 2)
	}elseif (AVType = "DAY"){
		s data = $p($P(ADataCode, " ", 1),"-",3)
	}elseif (AVType = "HOUR"){
		s data = $p($P(ADataCode, " ", 2),":",1)
	}elseif (AVType = "MINUTE"){
		s data = $p($P(ADataCode, " ", 2),":",2)
	}elseif (AVType = "SECOND"){
		s data = $p($P(ADataCode, " ", 2),":",3)
	}elseif (AVType = "YMDHM"){
		s data = $P(ADataCode," ",1)_" "_$E($P(ADataCode," ",2), 1, 5)  //YYYY-MM-DD HH:MM
	}elseif (AVType = "MDHM"){
		s tmpDate = $P(ADataCode," ",1)
		s tmpTime = $P(ADataCode," ",2)
		s data = $E(tmpDate,6,$L(tmpDate))_" "_$E(tmpTime, 1, 5)  //MM-DD HH:MM
	}elseif (AVType = "HM"){
		s data = $E($P(ADataCode," ",2),1,5)  //HH:MM
	}elseif (AVType = "YMD"){
		s data = $P(ADataCode, " ", 1)  //YYYY-MM-DD
	}elseif (AVType = "HMS"){
		s data = $P(ADataCode, " ", 2)   //HH:MM:SS
	}	
	q data
}

/// Desc: 转化回车和换行
ClassMethod ConvertChar(str As %String) As %String
{
	//转换 &EnterKey;
	set count = $Length(str, "&KeyEnter;")
    if count > 1
    {
	    set tmpStr = ""
		for I = 1:1:count
		{
			set tmpStr = tmpStr_$p(str,"&KeyEnter;",I)_$c(13) 
		}
		set str = $extract(tmpStr,1,$Length(tmpStr)-1)
    }
	//转换 &nbsp;
	set count = $Length(str, "&nbsp;")
	if count > 1
	{
		set tmpStr=""
		for I = 1:1:count
		{
			set tmpStr = tmpStr_$p(str,"&nbsp;",I)_$c(32)
		}
		set str = $extract(tmpStr,1,$Length(tmpStr)-1)
	}
	q str
}

/// Desc:	测试方法
/// Debug:	w ##Class(EPRservice.BLL.Query.BLEPRInfo).Test()
ClassMethod Test()
{
	s episodeID = "201871"
	s obj = ##Class(EPRservice.BLL.Query.BLGlossaryInfo).CreateInstance(episodeID)
	/*
	s itemPara = "首页一般情况.出生#TYPE:Simple#TID:844#TVER:0#SCODE:D0056#VTYPE:V"
	s ret = obj.GetEPRData(itemPara)
	w !, "Simple Value:"_ret
	
	s itemPara = "首页一般情况.出生#TYPE:Simple#TID:844#TVER:0#SCODE:D0056#VTYPE:C"
	s ret = obj.GetEPRData(itemPara)
	w !, "Simple ValueCode:"_ret
	
	s itemPara = "首页一般情况.出生#TYPE:Simple#TID:844#TVER:0#SCODE:D0056#VTYPE:YMD"
	s ret = obj.GetEPRData(itemPara)
	w !, "Simple YMD:"_ret
	
	s itemPara = "首页一般情况.出生#TYPE:Simple#TID:844#TVER:0#SCODE:D0056#VTYPE:HMS"
	s ret = obj.GetEPRData(itemPara)
	w !, "Simple HMS:"_ret
	
	s itemPara = "通用模板.主诉#TYPE:TextDesc#TID:709#TVER:0#ECODE:E0001"
	s ret = obj.GetEPRData(itemPara)
	w !, "TextDesc:"_ret
	
	s itemPara = "住院病历.病史.主诉.通用模板.颅内占位主诉|神经外科主诉.症状#TYPE:TextDescSimple#TID:709#TVER:0#TCODE:E0001#SCODE:M0004#VTYPE:V#KBNodeID:7753#KBPartNo:1"
	s ret = obj.GetEPRData(itemPara)
	w !, "TextDescSimple:"_ret
	
	s itemPara = "住院病历.病史.个人史.通用模板.吸烟史#TYPE:Segment#TID:724#TVER:0#GCODE:G0037"
	s ret = obj.GetEPRData(itemPara)
	w !, "Segment:"_ret
	
	s itemPara = "住院病历.病史.个人史.通用模板.吸烟史.吸烟史#TYPE:SegmentSimple#TID:724#TVER:0#TCODE:G0037#SCODE:O0007#VTYPE:V"
	s ret = obj.GetEPRData(itemPara)
	w !, "SegmentSimple:"_ret
	*/
    do obj.SetEpisodeID(episodeID)
	w obj.GetGlossaryData("10")
}

}

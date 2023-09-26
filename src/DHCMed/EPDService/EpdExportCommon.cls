/// 导出类的公共方法
/// 创建者：李阳
/// 创建时间：2015-05-18
Class DHCMed.EPDService.EpdExportCommon Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 根据字典ID获取字典描述
ClassMethod GetDicDescByID(DicID As %String) As %String
{
	n (DicID)
	Set ret=""
	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
	Quit:'$IsObject(objDic) ret
	Do objDic.%Close()
	Set ret=objDic.Description
	Set objDic=""
	Kill objDic
	Quit ret
}

/// 根据字典ID获取字典代码
ClassMethod GetDicCodeByID(DicID As %String) As %String
{
	n (DicID)
	Set ret=""
	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
	Quit:'$IsObject(objDic) ret
	Do objDic.%Close()
	Set ret=objDic.Code
	Set objDic=""
	Kill objDic
	Quit ret
}

/// 根据字典代码获取描述
ClassMethod GetDicDescByTypeCode(DicType As %String, DicCode As %String) As %String
{
	n (DicType,DicCode)
	Set ret=""
	Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode(DicType,DicCode,1)
	Quit:'$IsObject(objDic) ret
	Do objDic.%Close()
	Set ret=objDic.Description
	Set objDic=""
	Kill objDic
	Quit ret
}

/// 获取对照数据
/// 参数：
///     SrcValue ：原始值
///     DefaultValue: 如果没有对照成功，返回的值
///     DicName: 对应的字典名称
///     DisplayValue: 原始值对应的显示描述
/// 返回值：
///    列表：值^字典名称$C(2)值^字典名称
ClassMethod GetMap(SrcValue As %String, DefaultValue As %String, DicName As %String, DispValue As %String = "") As %String
{
	n (DefaultValue,SrcValue,DicName,rid,DispValue)
	Set ret=""
	;b:DicName="EpidemicSimpleSource"
	Set tDicName=" "_$ZConvert(DicName,"U")
	Set tSrcValue=" "_$ZConvert($TR(SrcValue," ",""),"U")
	Set RowID=$o(^DHCMed.EPD.IOMappingI("IndexCategorySrcID",tDicName,tSrcValue,""),-1)
	if (RowID="") {
		Set:SrcValue="是" ret="1"
		Set:SrcValue="否" ret="0"
		Set:SrcValue="Y" ret="1"
		Set:SrcValue="N" ret="0"

		
		Set:SrcValue="有" ret="1"
		Set:SrcValue="无" ret="2"		
		Set:SrcValue="不详" ret="9"
		
		Set:SrcValue["男" ret="1"
		Set:SrcValue["女" ret="2"	
		
		Set:ret="" ret=SrcValue	
		Set:$d(^CacheTemp(rid,"Unmap"))=0 ^CacheTemp(rid,"Unmap",0)=""
		Set ind=$o(^CacheTemp(rid,"Unmap",""),-1)+1
		
		if ("是否有无男女不详YN"'[SrcValue)&&(DicName'="") {
			Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode(DicName,SrcValue,1)
			Set:'$IsObject(objDic) objDic=##class(DHCMed.SS.Dictionary).%New()
			Do objDic.%Close()
			Set ^CacheTemp(rid,"Unmap",ind)="NotMapping^"_DicName_"^"_"字典未对照成功"_"^"_SrcValue_"^"_objDic.Description //只有有字典项目的才保存起来等待对照
		}
	}
	else
	{
		Set objMap=##class(DHCMed.EPD.IOMapping).GetObjById(RowID)
		Do objMap.%Close()
		Set IDCode=" "_$ZConvert(objMap.Target,"U")
		Set DicID=$o(^DHCMed.EPD.IODictionaryI("IndexIDCode",IDCode,""))
		Set objDic=##class(DHCMed.EPD.IODictionary).GetObjById(DicID)
		Set:'$IsObject(objDic) objDic=##class(DHCMed.SS.Dictionary).%New()
		Do objDic.%Close()
		Set ret=objDic.Code
		Set:ret="" ret=DefaultValue
	}
	//w DicName_"->"_SrcValue_"   ==>"_ret,!
	Quit ret
}

/// 获取一份报告中未对照的数据
/// 参数：
///    repid:节点ID
/// 返回值：
///    列表：值^字典名称$C(2)值^字典名称
ClassMethod GetUnMapData(repid As %String) As %String
{
	n (repid)
	Set ret=""
	Set ind=""
	For {
		Set ind=$o(^CacheTemp(repid,"Unmap",ind))
		Quit:ind=""
		Set:ret'="" ret=ret_$c(2)
		Set ret=ret_$g(^CacheTemp(repid,"Unmap",ind))
	}
	Kill ^CacheTemp(repid,"Unmap")
	Quit ret
}

/// 功能：将传染病附卡中的值存储在Global中
/// 参数：
///      RepID : 需要存储附卡信息的报告ID
/// 结果：
///      在Global中的节点值
/// w ##class(DHCMed.EPDService.EpdExportCommon).PrepareEpdSub(3)
ClassMethod PrepareEpdSub(RepID As %String) As %Integer
{
	n (RepID)
	Set ret=$I(^CacheTemp)
	Set ItemName=""
	Set ItemValue=""
	Set ItemDic=""
 	set rs=##class(%ResultSet).%New()
 	set rs.ClassName="DHCMed.EPDService.EpidemicSubSrv"
 	set rs.QueryName="QryEpidemicSub"
 	//RowID:%String,ItemCaption:%String:项目,ItemValue:%String:值,ItemType:%String,ItemDic:%String,AppendixItemID:%String,
 	//HiddenValue:%String,NoticeText:%String:提示,IsNecess:%String:是否必填
 	set sc=rs.Execute(RepID,"","")
 	while rs.%Next() { 
 		Set ItemName=rs.GetDataByName("ItemCaption")
 		Set ItemValue=rs.GetDataByName("HiddenValue")
 		Set ItemDispValue=rs.GetDataByName("ItemValue")
 		Set ItemDic=rs.GetDataByName("ItemDic")
 		Set ^CacheTemp(ret,ItemName)=ItemValue_"^"_ItemDic_"^"_ItemDispValue
 		//do rs.%Print() 
 	}
 	Do rs.%Close()
	Quit ret
}

/// 功能：获取存储在Global中传染病附卡的值
/// 参数：
///      repid: 在^CacheTemp存储的节点值
///      ItemName：项目名称，对应传染病附卡项目的名称
///      DefaultValue : 缺省值
/// 结果：
///      附卡值
ClassMethod GetRepSubValue(repid As %Integer, ItemName As %String, DefaultValue As %String = "") As %String
{
	n (ItemName,DefaultValue,repid,rid)
	Set v=$g(^CacheTemp(repid,ItemName))
	Set ret=..GetMap($p(v,"^",1),DefaultValue,$p(v,"^",2),$p(v,"^",3))
	
	;w ItemName_"--->"_v_"==>"_ret,!
	Quit ret
}

/// 用于比较两个字符串
/// 参数：
///    str1:待比较的第一个字符串
///    str2:待比较的第二个字符串
/// 返回值：
///    1:第一个字符大于第二个字符，0：第一个字符等于第二个字符，-1：第一个字符小于第二个字符
/// w ##class(DHCWMR.MQService.OutPutSrv).CompareString("ABC","ABD")
ClassMethod CompareString(str1, str2) As %Integer
{
	n (str1,str2)
	Set l1=$l(str1)
	Set l2=$l(str2)
	Set ln=$s(l1>l2:l1,1:l2)
	Set t1="",t2=""
	Set ret=0
	For i=1:1:ln {
		Set t1=$a(str1,i)
		Set t2=$a(str2,i)
		if (t1>t2)
		{
			Set ret=1
			Quit
		}
		if (t1<t2)
		{
			Set ret=-1
			Quit
		}
	}
	Quit ret
}

}

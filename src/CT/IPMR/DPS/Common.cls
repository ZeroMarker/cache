/// 名称: CT.IPMR.DPS.Common
/// 描述: DP包公共服务方法
/// 创建者：liyi
/// 创建日期: 2019-10-24
Class CT.IPMR.DPS.Common Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2021-12-17
/// Description:  主键ID获取系统对象
/// Input：       OID : 主键ID
/// Return：      返回CT.IPMR.DP.System
/// w ##class(CT.IPMR.DPS.Common).GetIdStringByExCode("")
ClassMethod GetIdStringByExCode(aId As %String, aExCode As %String) As %String
{
	New (aId,aExCode)
	Set return=""
	Quit:(aId="")||(aExCode="") return
	Set objSys = ##class(CT.IPMR.DP.System).GetObjByExCode(aExCode)
	Quit:'$IsObject(objSys) return
	
	Set return = aId_"||"_objSys.%Id()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2021-12-17
/// Description:  主键ID获取系统对象
/// Input：       OID : 主键ID
/// Return：      返回CT.IPMR.DP.System
/// w ##class(CT.IPMR.DPS.Common).GetSysIdByOID("")
ClassMethod GetSysIdByOID(OID As %String) As CT.IPMR.DP.System
{
	New (OID)
	Set return=""
	Quit:(OID="") return
	Quit:$p(OID,"||",2)="" return
	Set objSys = ##class(CT.IPMR.DP.System).GetObjById($p(OID,"||",2))
	Quit:'$IsObject(objSys) return
	Quit objSys
}

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  拼接第三方数据id和系统id
/// Table：       CT.IPMR.DP.System
/// Input：       aId : 第三方字典ID
/// 			  aSysId : 字典来源第三方系统id
/// Return：      返回String
/// w ##class(CT.IPMR.DPS.Common).GetIdString("")
ClassMethod GetIdString(aId As %String, aSysId As %String) As %String
{
	New (aId,aSysId)
	Set return=""
	Quit:(aId="")||(aSysId="") return
	
	Set objSys = ##class(CT.IPMR.DP.System).GetObjById(aSysId)
	Quit:'$IsObject(objSys) return
	
	Set return = aId_"||"_aSysId
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2018-09-19
/// Description:  解析XML流
/// Input：       XML格式流的信息
/// Return：      List对象
/// w ##Class(DHCWMR.IO.Common).GetListByXML("<Response><Item><TempID>2||1</TempID><EpisodeID>20</EpisodeID><Code>NISCowwwwwwwwwwde2</Code><Desc>NISNaw3333333333333me2</Desc><Value>39℃</Value><EntryDate>2017-07-04</EntryDate><EntryTime>12:12:34</EntryTime><EntryUserCode>INPCode</EntryUserCode><EntryUser>INPName</EntryUser><IsActive>1</IsActive></Item><Item><TempID>3||3</TempID><EpisodeID>49</EpisodeID><Code>NISC11111ode2</Code><Desc>NISN2222ame2</Desc><Value>35℃</Value><EntryDate>2017-07-11</EntryDate><EntryTime>12:13:34</EntryTime><EntryUserCode>INPCo33333de</EntryUserCode><EntryUser>INPName3333</EntryUser><IsActive>1</IsActive></Item></Response>")
ClassMethod GetListByXML(aInputxml As %GlobalCharacterStream, Output arrData As %List) As %Status
{
	New (aInputxml,arrData)
	Set return=""

	Set sc =##class(%XML.TextReader).ParseStream(aInputxml,.reader)
	If $$$ISERR(sc) {
		Do $system.OBJ.DisplayError(sc)
		Write "打开XML文件失败,请检查文件是否为格式良好的XML文件!",!
		Set return=$Lb("")
		Quit return
	}
	Kill arrData
	Do reader.Rewind()
	Set Count=0
	While (reader.Read()) {
		If (reader.NodeType="element") {
			Set node=reader.Name
			If (node="Items") {		    //根节点
				Set Count=Count+1		//处理一个xml多个患者信息的问题
			}
		} ElseIf (reader.NodeType="chars"){
			Set path=reader.Path
			if path["SysCode"{
				Set ItemName= $p(path,"/",$l(path,"/"))
				Set arrData(ItemName)=reader.Value
			}
			If $g(path)'="" {
				Set ItemName= $p(path,"/",$l(path,"/"))
				Set arrData(Count,ItemName)=reader.Value
			}
		}
	}
	Quit $$$OK
}

}

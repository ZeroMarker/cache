/// 名称: DHCHAI.Utils.XMLReaderSrv
/// 描述: XML解析服务类
/// 编写者：zhufei
/// 编写日期: 2017-08-08
Class DHCHAI.Utils.XMLReaderSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-07-13
/// Description:  解析XML
/// Input：       XML格式的患者信息
/// Return：      List对象
/// w ##Class(DHCHAI.Utils.XMLReaderSrv).GetListByXML("<Response><Item><TempID>2||1</TempID><EpisodeID>20</EpisodeID><Code>NISCowwwwwwwwwwde2</Code><Desc>NISNaw3333333333333me2</Desc><Value>39℃</Value><EntryDate>2017-07-04</EntryDate><EntryTime>12:12:34</EntryTime><EntryUserCode>INPCode</EntryUserCode><EntryUser>INPName</EntryUser><IsActive>1</IsActive></Item><Item><TempID>3||3</TempID><EpisodeID>49</EpisodeID><Code>NISC11111ode2</Code><Desc>NISN2222ame2</Desc><Value>35℃</Value><EntryDate>2017-07-11</EntryDate><EntryTime>12:13:34</EntryTime><EntryUserCode>INPCo33333de</EntryUserCode><EntryUser>INPName3333</EntryUser><IsActive>1</IsActive></Item></Response>")
ClassMethod GetListByXML(aInputxml As %String, Output arrData As %List) As %Status
{
	New (aInputxml,arrData)
	Set return=""
	Set xmlStream=##class(%GlobalCharacterStream).%New()
    Do xmlStream.Rewind()
	Do xmlStream.Write(aInputxml)
	Do xmlStream.%Close()
	
	Set sc =##class(%XML.TextReader).ParseStream(xmlStream,.reader)
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
			If (node="Item") {		    //根节点
				Set Count=Count+1		//处理一个xml多个患者信息的问题
			}
		} ElseIf (reader.NodeType="chars"){
			Set path=reader.Path
			If $g(path)'="" {
				Set ItemName= $p(path,"/",$l(path,"/"))
				Set arrData(Count,ItemName)=reader.Value
			}
		}
	}
	Quit $$$OK
}

}

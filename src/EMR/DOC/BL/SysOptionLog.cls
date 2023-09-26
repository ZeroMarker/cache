/// 名称:	EMR.DOC.BL.SysOptionLog
/// 描述:	系统参数操作日志获取
/// 编写者：huhao
/// 编写日期: 2021-11-29
/// 产品组：电子病历产品组
Class EMR.DOC.BL.SysOptionLog Extends EMR.DOC.COM.ActionBase
{

/// Creator:	huhao
/// CreatDate:  2021/11/30
/// Desc:		获取系统参数操作日志
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod GetSystemOptionLog(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s name=argInJson.params.UserName
	s StartTime=argInJson.params.startTime
	s EndTime=argInJson.params.endTime
    s strRes = ##class(EMR.DOC.BL.SysOptionLog).GetLog(name,StartTime,EndTime,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查询到内容",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod GetLog(Name As %String, StartTime As %String, EndTime As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s countc="",rowId=1,i=1
	s resJson=##class(%DynamicArray).%New()
	&sql(select count(*)into countc from CF_EMR_DOC.SysOptionLog)
	for i=1:1:countc
	{
		s resObj=##class(%DynamicObject).%New()
		s obj = ##Class(CF.EMR.DOC.SysOptionLog).%OpenId(rowId)
		q:(obj= "")
		s rowId=rowId+1
		s opTime=obj.OperateDate
		;$ZDATEH($Piece(obj.OperateDate,"-",2)_"/"_$Piece(obj.OperateDate,"-",3)_"/"_$Piece(obj.OperateDate,"-",1))
		if ((StartTime="")&&(EndTime="")&&(Name=""))
		{
			d setJson
		}
		elseif((StartTime="")&&(EndTime="")&&(Name'=""))
		{
			if ($find(obj.OperateUserName,Name)'=0)
			{
				d setJson
			}
			else {break}
		}
		elseif((StartTime'="")&&(EndTime'="")&&(Name=""))
		{
		s sTime=$ZDATEH( $Piece(StartTime,"-",2)_"/"_$Piece(StartTime,"-",3)_"/"_$Piece(StartTime,"-",1))
	  	s eTime=$ZDATEH($Piece(EndTime,"-",2)_"/"_$Piece(EndTime,"-",3)_"/"_$Piece(EndTime,"-",1))

			if ((opTime>=sTime)&&(opTime<=eTime))
			{
				d setJson
			}
			else {break}
			
		}
		else
		{
		s sTime=$ZDATEH( $Piece(StartTime,"-",2)_"/"_$Piece(StartTime,"-",3)_"/"_$Piece(StartTime,"-",1))
	  	s eTime=$ZDATEH($Piece(EndTime,"-",2)_"/"_$Piece(EndTime,"-",3)_"/"_$Piece(EndTime,"-",1))
			if ((opTime>=sTime)&&(opTime<=eTime)&&($find(obj.OperateUserName,Name)'=0))
			{
				d setJson
			}
			else {break}
		}
		
	}
	d resJson.%ToJSON(argOutData)
	q "1"
setJson
	s resObj.key=rowId-1
	s resObj.UserName=obj.OperateUserName
	s resObj.OptionIp=obj.OperateMachineIP
	s resObj.OldName=obj.OldName
	s resObj.OldDes=obj.OldDescription
	s resObj.OldValue=obj.OldOptionValue
	s resObj.NewName=obj.NewName
	s resObj.NewDes=obj.NewDescription
	s resObj.NewValue=obj.NewOptionValue
	s firstTime=$zdate(obj.OperateDate)
	s lastTime=$piece(firstTime,"/",3)_"-"_$piece(firstTime,"/",1)_"-"_$piece(firstTime,"/",2)
	s resObj.OptionTime=lastTime
	s resObj.Action=obj.Action
	d resJson.%Push(resObj)
}

}

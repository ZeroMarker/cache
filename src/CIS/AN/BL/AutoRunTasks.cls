/// 自动任务类
Class CIS.AN.BL.AutoRunTasks Extends %RegisteredObject
{

Parameter Fields = "PreOperNote,PreMedication";

/// Creator：      	雍阳
/// CreatDate：    	2018-11-14
/// Description： 	汇总前一日数据项使用次数和文本历史记录，自动插入数据库
/// Table：        	CT.AN.OperSchedule
/// Input:			
/// Return：       	
/// d ##class(CIS.AN.BL.AutoRunTasks).AutoRefreshCounter()
ClassMethod AutoRefreshCounter() As %String
{
	set date = $zdh("2020-09-08",3) //+$h - 1
	do ..SumDataItemUsage(date)
	//do ..SumInputTextHistory(date)
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-9
/// Description： 	汇总每日数据项使用次数，自动插入数据库
/// Table：        	CT.AN.OperSchedule
/// Input:			date：日期
/// Return：       	
/// d ##class(CIS.AN.BL.AutoRunTasks).SumDataItemUsage("2018-11-09")
ClassMethod SumDataItemUsage(date As %String) As %String
{
	set moduleCode = "AnaestRecord"
	set moduleId = ##class(CIS.AN.BL.DataModule).GetDataModuleID(moduleCode)
	set operScheduleList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperScheduleList:FindOperScheduleList",date,date,"","","","","RoomOut^Finish")
	
	set operSchedule=""
	for i=1:1:(operScheduleList.Size)
	{
		set operSchedule=operScheduleList.GetAt(i)
		quit:operSchedule=""
		set opsId=operSchedule.GetValue("RowId")
		do ..CalculateDataItemUsage(moduleId,opsId)
	}
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-9
/// Description： 	汇总单个手术数据项使用次数
/// Table：        	CT.AN.AnaData, CT.AN.DrugData
/// Input:			date：日期
/// Return：       	
/// d ##class(CIS.AN.BL.AutoRunTasks).SumDataItemUsage("2018-11-09")
ClassMethod CalculateDataItemUsage(moduleId As %String, opsId As %String) As %String
{
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetId(opsId,moduleId,"")
	set anaDataList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindAnaDatas",recordSheetId,"N")
	
	set anaData=""
	for i=1:1:(anaDataList.Size)
	{
		set anaData=anaDataList.GetAt(i)
		quit:anaData=""
		
		set ItemCategory=anaData.GetValue("ItemCategory")
		set DataItem=anaData.GetValue("DataItem")
		set UserDefinedItem=anaData.GetValue("UserDefinedItem")
		
		continue:(ItemCategory'="E") //先主要生成事件项目的计数
		
		//if DataItem'="" do ..AddDataItemCounter(DataItem)
		if UserDefinedItem'="" do ..AddUserDefItemCounter(UserDefinedItem)
	}
	
	
	//生成药品项目的计数
	set drugDataList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindDrugDatas",recordSheetId)
	
	set drugData=""
	for i=1:1:(drugDataList.Size)
	{
		set drugData=drugDataList.GetAt(i)
		quit:drugData=""
		
		set DataItem=drugData.GetValue("DataItem")
		set UserDefinedItem=drugData.GetValue("UserDefinedItem")
		
		if DataItem'="" do ..AddDataItemCounter(DataItem)
		if UserDefinedItem'="" do ..AddUserDefItemCounter(UserDefinedItem)
	}
	
	quit "over"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-9
/// Description： 	汇总历史输入文本，自动插入数据库
/// Table：        	CT.AN.AnaData, CT.AN.DrugData
/// Input:			date：日期
/// Return：       	
/// d ##class(CIS.AN.BL.AutoRunTasks).AddDataItemCounter("2")
ClassMethod AddDataItemCounter(dataItem) As %String
{
	set counterId=$o(^CT.AN.DataItemCounterI("Item",dataItem,""))
	if (counterId=""){
		set data("ClassName")="CT.AN.DataItemCounter"
		set data("DataItem")=dataItem
		set data("Counter")=1
		do ##class(CIS.AN.COM.DataService).SaveData(.data)
	}
	else
	{
		set instance = ##class(CT.AN.DataItemCounter).%OpenId(counterId)
		set instance.Counter=instance.Counter+1
		
		set rs = instance.%Save()
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-9
/// Description： 	汇总历史输入文本，自动插入数据库
/// Table：        	CT.AN.AnaData, CT.AN.DrugData
/// Input:			date：日期
/// Return：       	
/// d ##class(CIS.AN.BL.AutoRunTasks).AddUserDefItemCounter("2")
ClassMethod AddUserDefItemCounter(UserDefinedItem) As %String
{
	set counterId=$o(^CT.AN.UserDefItemCounterI("Item",UserDefinedItem,""))
	if (counterId=""){
		set data("ClassName")="CT.AN.UserDefItemCounter"
		set data("UserDefinedItem")=UserDefinedItem
		set data("Counter")=1
		do ##class(CIS.AN.COM.DataService).SaveData(.data)
	}
	else
	{
		set instance = ##class(CT.AN.UserDefItemCounter).%OpenId(counterId)
		set instance.Counter=instance.Counter+1
		
		set rs = instance.%Save()
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-9
/// Description： 	汇总历史输入文本，自动插入数据库
/// Table：        	CT.AN.AnaData, CT.AN.DrugData
/// Input:			date：日期
/// Return：       	
/// d ##class(CIS.AN.BL.AutoRunTasks).SumInputTextHistory("2018-11-06")
ClassMethod SumInputTextHistory(date) As %String
{
	set moduleCode = "AnaestRecord"
	set moduleId = ##class(CIS.AN.BL.DataModule).GetDataModuleID(moduleCode)
	set operScheduleList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperSchedule:FindOperScheduleList",date,date,"","","","","RoomOut^Finish")
	
	set operSchedule=""
	for i=1:1:(operScheduleList.Size)
	{
		set operSchedule=operScheduleList.GetAt(i)
		quit:operSchedule=""
		set opsId=operSchedule.GetValue("RowId")
		do ..CountInputTextHistory(moduleId,opsId)
	}
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-9
/// Description： 	汇总手术中历史输入文本
/// Table：        	CT.AN.AnaData, CT.AN.DrugData
/// Input:			date：日期
/// Return：       	
/// d ##class(CIS.AN.BL.AutoRunTasks).CountInputTextHistory("2018-11-09")
ClassMethod CountInputTextHistory(moduleId As %String, opsId As %String) As %String
{
	set instance = ##class(CT.AN.OperSchedule).%OpenId(opsId)
	
	set fields = ..#Fields
	for i=1:1:$l(fields,",")
	{
		set propertyName = $p(fields,",",i)
		set propertyValue = $property(instance,propertyName)
		if propertyValue'=""
		{
			set textList = ..SplitText(propertyValue)
			do ..SaveTextHistoryCounter(moduleId,propertyName,textList)
		}
		
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-9
/// Description： 	分割字符串
/// Table：        	CT.AN.AnaData, CT.AN.DrugData
/// Input:			date：日期
/// Return：       	
/// w ##class(CIS.AN.BL.AutoRunTasks).SplitText("高血压，阿士大夫  药物不耐受")
ClassMethod SplitText(textStr) As %List
{
	set textStr = $replace(textStr,"，"," ")
	set textStr = $replace(textStr,"；"," ")
	set textStr = $replace(textStr,";"," ")
	set textStr = $replace(textStr,":"," ")
	set textStr = $replace(textStr,"+"," ")
	set textStr = $replace(textStr,"、"," ")
	set textStr = $replace(textStr,","," ")
	set textStr = $replace(textStr,$c(10)," ")
	set result = $ListFromString(textStr," ")
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-9
/// Description： 	保存
/// Table：        	CT.AN.AnaData, CT.AN.DrugData
/// Input:			date：日期
/// Return：       	
/// d ##class(CIS.AN.BL.AutoRunTasks).SaveTextHistoryCounter("2","PreMedication",$lb("ss","saas"))
ClassMethod SaveTextHistoryCounter(moduleId As %String, field As %String, textList As %List) As %String
{
	set IndexField=$ZCVT(field,"U")
	for i=1:1:$ll(textList)
	{
		set text = $lg(textList,i)
		continue:text=""
		
		set IndexText=$ZCVT(text,"U")
		set counterId=$o(^CT.AN.InputTextHistoryI("ModuleText",moduleId," "_IndexField," "_IndexText,""))
		if (counterId=""){
			set data("ClassName")="CT.AN.InputTextHistory"
			set data("DataModule")=moduleId
			set data("Field")=field
			set data("Text")=text
			set data("Counter")=1
			do ##class(CIS.AN.COM.DataService).SaveData(.data)
		}
		else
		{
			set instance = ##class(CT.AN.InputTextHistory).%OpenId(counterId)
			set instance.Counter=instance.Counter+1
		
			set rs = instance.%Save()
		}
	}
	
	quit ""
}

}

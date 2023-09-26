/// Function:     CDSS别名维护
/// CreateDate:   2021-11-05
/// Creator:      基础数据平台组 - 谷雪萍
Class web.CDSS.CMKB.Alias Extends %RegisteredObject
{

/// Function: 保存数据时调用方法
/// CreateDate: 2021-11-05
/// Creator:  基础数据平台组-谷雪萍
/// Input: TableName-表名，DataID-数据id，AliasStr-别名串，用英文逗号分割
/// Output:返回成功或失败的json信息
/// Other:d ##class(web.CDSS.CMKB.Alias).SaveAlias(TableName,DataID,AliasStr)
ClassMethod SaveAlias(TableName As %String, DataID As %String, AliasStr As %String) As %String
{
	q:(TableName="")||(DataID="") "{success:'false',errorinfo:'保存到别名表时表名和数据ID不能为空！'}" 

	s AliasResult="" 
	s AliasLen=$length($g(AliasStr),",")
	TS
	s AliasResult =##class(web.CDSS.CMKB.Alias).DeleteAlias(TableName,DataID)  //先删除别名
	if (AliasResult["true")&(AliasStr'="")  //再保存别名
	{
		for iAlias=1:1:AliasLen 
		{
			s Alias=$p($g(AliasStr),",",iAlias)
			continue:Alias=""
			if ($d(^CT.WDT.CDSS.AliasI("AliasIndex",TableName,Alias,DataID))>0)
			{
				continue
			}
			s AliasObj=##class(CT.WDT.CDSS.Alias).%New()
			s AliasObj.TableName=TableName
			s AliasObj.DataAlias=Alias
			s AliasObj.DataReference=DataID
			s AliasSC=AliasObj.%Save()    
			if '$$$ISOK(AliasSC)
			{	
				s AliasResult = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(AliasSC)_"'}"  //返回错误信息
				q
			}  

		}
	}
	if (AliasResult["false")
	{
		tro
	}
	else
	{
		tc
		s AliasResult = "{success:'true',info:'别名保存成功！'}" //返回RowId
	}
	q AliasResult
}

/// Function: 删除数据时调用方法
/// CreateDate: 2021-11-05
/// Creator:  基础数据平台组-谷雪萍
/// Input: TableName-表名，DataID-数据id
/// Output:返回成功或失败的json信息
/// Other:d ##class(web.CDSS.CMKB.Alias).DeleteAlias(TableName,DataID)
ClassMethod DeleteAlias(TableName As %String, DataID As %String) As %String
{
	s DeleteResult="" 
	; 判断是否有别名时的删除，当没有别名却要执行全部删除别名时为了删除数据
	; 需要在没别名的全删除时返回一个 {sucess:true}
	if ($d(^CT.WDT.CDSS.AliasI("DataRefIndex",TableName,DataID))>0) 
	{
		TS
		s AliasID=0
		for 
		{ 
			s AliasID=$o(^CT.WDT.CDSS.AliasI("DataRefIndex",TableName,DataID,AliasID)) 
			q:AliasID=""   

			s DeleteSC=##class(CT.WDT.CDSS.Alias).%DeleteId(AliasID)
			IF '$$$ISOK(DeleteSC)
			{
				s DeleteResult="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(DeleteSC)_"'}"  //返回错误信息
				q
			} 
		}
		if (DeleteResult["false")
		{
			tro
		}
		else
		{
			tc
			s DeleteResult = "{success:'true',info:'别名删除成功！'}" 
		}
	}
	else
	{
		s DeleteResult="{success:'true',info:'没有别名不需要删除！'}"
	}
	q DeleteResult
}

/// Function: 所有基础字典统一生成别名数据【清空别名表，遍历配置表，执行别名生成接口】
/// CreateDate: 2023-03-16
/// Creator:  基础数据平台组-赵文伟
/// Input: 
/// Output:返回成功或失败的json信息
/// Other:d ##class(web.CDSS.CMKB.Alias).SaveAllAliasData()
ClassMethod SaveAllAliasData() As %String
{
	k ^CT.WDT.CDSS.AliasI	//清空别名表数据
	k ^CT.WDT.CDSS.AliasD
	
	s ParentDR=$o(^CF.WDT.CDSS.StatisticsConfigI("DescIndex"," 基础字典库",0))
	s ID=""
	for
	{
		s ID=$o(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",ParentDR,ID)) q:ID=""
		s AliasInfo=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(ID)),10)   //别名接口
		if (AliasInfo'=""){
			s ClassName=$e(AliasInfo,$locate(AliasInfo,"\(")+1,$locate(AliasInfo,"\)")-1)
			//判断接口存在再执行
			s Exist= ##class(web.DHCBL.BDP.FunLib).IsValidMethodName(ClassName,"TransferAliasData")
			if (Exist="1"){
				x "d "_AliasInfo	//执行接口
			} else{
				w ClassName_"中接口不存在!"
			}
		}
	}
	w "success!"
}

}

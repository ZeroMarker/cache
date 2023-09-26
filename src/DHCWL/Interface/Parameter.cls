/// 	定义了参数对象及对参数的存取操作
Class DHCWL.Interface.Parameter Extends %RegisteredObject
{

Property aryParamObj As array Of %ObjectHandle;

Property startDate As %String;

Property endDate As %String;

Property choiceType As %String [ InitialExpression = "freeDateChoice" ];

Property isRealData As %String;

Property filterRule As %Text(MAXLEN = 512);

//4.2新增

Property aryDts As %Library.ArrayOfDataTypes;

//4.2新增

Property aryObjs As %Library.ArrayOfObjects;

Method setStartDate(sDate As %String)
{
	s ..startDate=sDate
}

Method setEndDate(eDate As %String)
{
	s ..endDate=eDate
}

Method getStartDate() As %String
{
	q ..startDate
}

Method getEndDate() As %String
{
	q ..endDate
}

Method setChoiceType(ct As %String)
{
	s ..choiceType=ct
}

Method setIsRealData(rd As %String)
{
	s ..isRealData=rd
}

Method setFilterRule(fr As %Text)
{
	s ..filterRule=fr
}

Method getChoiceType() As %String
{
	q ..choiceType
}

Method getIsRealData() As %String
{
	q ..isRealData
}

Method getFilterRule() As %Text
{
	q ..filterRule
}

/// 描述: 设置参数值
/// 参数: 	value：		参数值
/// 	 	key：		参数的ID
/// 返回类型：	%Status
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-7
Method set(value As %ObjectHandle, key As %String) As %Status
{
	q ..aryParamObj.SetAt(value,key)
}

/// 描述: 得到参数值
/// 参数: 	key：		参数的ID
/// 返回类型：	ObjectHandle
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-7
Method get(key As %String) As %ObjectHandle
{
	q ..aryParamObj.GetAt(key)
}

/// 描述: 设置参数值
/// 参数: 	value：		参数值
/// 	 	key：		参数的ID
/// 返回类型：	%Status
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-7
Method SetByType(value, key As %String, type As %String) As %Status
{
	if type="Dts" {
		d ..aryDts.SetAt(value,key)
	}elseif type="Obj" {
		d ..aryObjs.SetAt(value,key)
	}else {
		q 0	
	}
}

/// 描述: 得到参数值
/// 参数: 	key：		参数的ID
/// 返回类型：	ObjectHandle
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-7
Method GetByType(key As %String, type As %String) As %ObjectHandle
{
	if type="Dts" {
		q ..aryDts.GetAt(key)
	}elseif type="Obj" {
		q ..aryObjs.GetAt(key)
	}else {
		q 0	
	}
}

/// 描述: 得到参数值
/// 参数: 	key：		参数的ID
/// 返回类型：	ObjectHandle
/// 返回值：	
/// 编写者： 王峥
/// 编写日期:2014-2-7
Method ClearByType(type As %String) As %ObjectHandle
{
	if type="Dts" {
		q ..aryDts.Clear()
	}elseif type="Obj" {
		q ..aryObjs.Clear()
	}else {
		s st=..aryDts.Clear()
		if $$$ISOK(st) {
			q ..aryObjs.Clear()
		}else{
			q st
		}

	}
}

}

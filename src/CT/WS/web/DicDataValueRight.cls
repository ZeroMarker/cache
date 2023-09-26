Class CT.WS.web.DicDataValueRight Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s strcondition = $Get(%request.Data("nodeidright",1),"")
	s start = $g(%request.Data("start",1),"0")
	s limit = $g(%request.Data("limit",1),"100")
	s lastIndex=limit+start-1
	d ..GetDataElementValueJsonDate(strcondition,start,lastIndex)
	
    Quit $$$OK
}

/// Creator:	yejian
/// CreatDate:	2013-4-23
/// Desc:		获取字典表维护数据
/// Input：		start：每页开始行数，limit：每页行数，actionbtn：前台触发事件，datavalue，前台传入的更新数据
/// Return：	"0":删除失败	"1":删除成功	
/// d ##Class(CT.WS.web.DicDataValueRight).GetDataElementValueJsonDate("1")
ClassMethod GetDataElementValueJsonDate(strRowID As %String, start As %Integer, lastIndex As %Integer)
{
   	if (strRowID=""&strRowID=$char(0))
	{
		q ""
	}
	//获取DECVMID根据Rowid
	s objEDEValuesCategory = ##Class(CT.WS.BO.BODataElementValuesCategory).SelectDEValuesCategoryById(strRowID)
	s strDECVMID = objEDEValuesCategory.DECVMID
	q:strDECVMID="" ""
	
	//获取最新字典维护数据
	s Result = ##Class(%ResultSet).%New("CT.WS.DataElementValues:SelectAllByDECVMID")
	d Result.Execute(strDECVMID)
 	//构造json数据
 	s json = ""
    s strv = ""
    s count =0
 	while(Result.Next())
 	{
	 	s strtext = ""
	 	 if ((count<=lastIndex)&(count>=start)){
	 	s strtext = $g(Result.Data("DECVMID")) _" "_$g(Result.Data("Name"))
	 	s json = json_"{CtmDictCode:'"_$g(Result.Data("DEVID"))_"',"
	 	s json = json_"CtmDictDesc:'"_$g(Result.Data("Meaning"))_"'},"
	 	
 	}
 	s count=count+1
	}
    s json = $e(json, 1, $l(json)-1)
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s set1 ="{results:"_count_",rows:["_json_"]}"
	w set1
}

Storage Default
{
<Data name="DicDataValueRightDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CT.WS.web.DicDataValueRightD</DataLocation>
<DefaultData>DicDataValueRightDefaultData</DefaultData>
<IdLocation>^CT.WS.web.DicDataValueRightD</IdLocation>
<IndexLocation>^CT.WS.web.DicDataValueRightI</IndexLocation>
<StreamLocation>^CT.WS.web.DicDataValueRightS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

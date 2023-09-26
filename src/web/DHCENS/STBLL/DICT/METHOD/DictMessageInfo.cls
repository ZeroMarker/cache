Class web.DHCENS.STBLL.DICT.METHOD.DictMessageInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.DICT.METHOD.DictMessageInfo).DictMessageInfo("SS_User,2729")
ClassMethod DictMessageInfo(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	/// 获取日志表中关联ID  User.BDPDataChangeLog
	set rowID=$p(Input,",",2)
	set KeyName=$p(Input,",",1)
	if KeyName="PAC_Ward" {
		set dictRowId=rowID
		/// 表名称
		set tableName=KeyName
	}
	elseif KeyName="CTLoc_RowID"
	{
		set dictRowId=rowID
		set tableName="CT_Loc"
	}
	else {
		set dictRowId=$lg(^User.BDPDataChangeLogD(rowID),4)
		/// 表名称
		set tableName=$lg(^User.BDPDataChangeLogD(rowID),2)
	}
	b ;
	set methodInfo=""
	set tSC=..MethodInfo(tableName,.methodInfo,dictRowId)
	if tSC="-1^方法不存在!" {
		set stream=##class(%GlobalCharacterStream).%New()
		d stream.Write("-1^方法不存在!")
		q stream
	}
	s @methodInfo
	set result=@"rtn"
	Quit result
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod MethodInfo(KeyName As %String, Output methodInfo As %String, Input...) As %String
{
	set $zt="Exception"
	q:(""=KeyName) "-1^方法代码为空!"
	s rowId=$o(^User.EnsInterfaceMethodI("MethodCode","classMethod",KeyName,""))
	s methodObj=##class(User.EnsInterfaceMethod).%OpenId(rowId)
	if '$isobject(methodObj){
		q "-1^方法不存在!"
	}
	s methodStatus=methodObj.methodStatus
	if (methodStatus="N") {
		q "-1^方法未启用!"
	}
	s className=methodObj.methodClassName
	s methodName=methodObj.methodName
	s methodInput=methodObj.methodInput
	s OutputType=$p($p(methodObj.methodOutput,$char(28),1),$char(2),1)
	s OutputDesc=$p($p(methodObj.methodOutput,$char(28),1),$char(2),2)
	s tmpInput="",tmpSubInput="",perInput="",IntInputDesc=""
	
	f i=1:1:$g(Input,0){
		s @("Input"_i)=$g(Input(i),"<NULL>")
		s tInputType=$p($p(methodInput,$char(28),i),$char(2),1)
		s tmpSubInput=$g(Input(i),"<NULL>")
		s tmpIntInputDesc=$p($p(methodInput,$char(28),i),$char(2),3)
		if (IntInputDesc=""){
			s IntInputDesc=tmpIntInputDesc
		}else{
			s IntInputDesc=IntInputDesc_$char(2)_tmpIntInputDesc
		}
		if (tInputType="%GlobalCharacterStream"){
			s tmpSubInput=tmpSubInput.Read()
			s tsc=Input(i).Rewind()
		}
		if (tmpInput=""){
			s tmpInput="Input"_i
			s perInput=tmpSubInput
		}else{
			s tmpInput=tmpInput_","_"Input"_i
			s perInput=perInput_","_tmpSubInput
		}
	}
	s methodInfo="rtn=##class("_className_")."_methodName_"("_tmpInput_")"
	Quit "1"
Exception
	s methodInfo=""
	Quit "-1^"_$ze
}

}

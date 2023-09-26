/// 建立一个统一的组件属性类
Class web.BDP.ext.entity.Component Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Property disabled As %String;

Property hidden As %String;

Property hideMode As %String;

Property id As %String;

Property renderTo As %String;

Property xtype As %String;

Method GetJosnData() As %String
{
	s myjosnstr=""
	i (..disabled'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"disabled"_":"_"'"_..disabled_"'"
	}
	
	i (..hidden'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""hidden"""_":"_""""_..hidden_""""
	}
	
	i (..hideMode'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""hideMode"""_":"_""""_..hideMode_""""
	}

	i (..id'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""id"""_":"_""""_..id_""""
	}

	i (..renderTo'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""renderTo"""_":"_""""_..renderTo_""""
	}

	i (..xtype'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""xtype"""_":"_""""_..xtype_""""
	}

	s myjosnstr="{"_myjosnstr_"}"
	
	q myjosnstr
}

}

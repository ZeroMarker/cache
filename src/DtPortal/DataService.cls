/// 名称: DtPortal.DataService
/// 描述: 医院统一协同平台
///       Portal数据提取接口  
/// 编写者：wuqk
/// 编写日期: 2012-2-8
Class DtPortal.DataService Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// Namespace.
/// Each web service needs to supply this parameter.
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// This is the name of our web service.
/// Each web service needs to supply this parameter.
Parameter SERVICENAME = "SOAPBase";

/// 输出数据流
Property XmlStream As %Library.GlobalCharacterStream;

//%XML.GlobalCharacterStream;

/// 结果集
Property Source As %ResultSet;

/// xml 标题
Parameter XmlTitle = "<?xml version=""1.0"" encoding=""utf-8"" ?>";

/// Creator：     wuqk
/// CreatDate：   2012-2-8
/// Description:  根据ClassName:Query返回结果集,转换为xml输出
/// Table：       
/// Input：       clsName : 类名称
///               queryName : query名称
///               p1-p16 : 参数
/// Return：  
/// w ##class(DtPortal.DataService).GetRecordSetData("DtPortal.Doctor.ScientificResearch","ScientificSubjQuery","","","")    
ClassMethod GetRecordSetData(clsName, queryName, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) As %Library.GlobalCharacterStream [ WebMethod ]
{
	set qdf=##class(%Dictionary.QueryDefinition).%OpenId(clsName_"||"_queryName)
	quit:'$IsObject(qdf) "Service:"_clsName_":"_queryName_" is not found."
	
	set paras=qdf.FormalSpec
	set:paras="" parasCount=0
	set:paras'="" parasCount=$l(paras,",")
	set rs=##class(%ResultSet).%New(clsName_":"_queryName)
	
	if parasCount=0 {d rs.Execute()}
	else{
		set execute="s sc=rs.Execute(",i=0
		set execute="set %sc=$zobjmethod(rs,""Execute"",",i=0
		while (i<parasCount){
			set i=i+1
			set execute=execute_"$g(p"_i_")"
			if (i<parasCount) {set execute=execute_","}
			b ////3456
		}
		set execute=execute_")"
		s ^TempPortal($i(^TempPortal))=execute
		x execute
	}
	
	set obj=..%New()
	set obj.Source=rs
	
	do obj.WriteXml()
	b ///22
	quit obj.XmlStream
}

/// Creator：     wuqk
/// CreatDate：   2012-2-8
/// Description:  执行ClassName:ClassMethod，返回结果
/// Table：       
/// Input：       clsName : 类名称
///               mthName : 类方法名称
///               p1-p16 : 参数
/// Return：      
ClassMethod RunMethod(clsName, mthName, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) As %Library.String [ WebMethod ]
{
	set clsName=$g(clsName)
	set mthName=$g(mthName)
	s mdf=##class(%Dictionary.CompiledMethod).%OpenId(clsName_"||"_mthName)
	
	quit:'$IsObject(mdf) "Service:"_clsName_":"_mthName_" is not found."
	set ret=""
	set paras=mdf.FormalSpec
	set:paras="" parasCount=0
	set:paras'="" parasCount=$l(paras,",")
	
	set execute="s ret=$ZOBJCLASSMETHOD(clsName,mthName"
	if parasCount=0 {set execute=execute_")"}
	else {
		set i=0
		while (i<parasCount){
				set i=i+1
				set execute=execute_",$g(p"_i_")"
			}
		set execute=execute_")"
		s ^TempPortal($i(^TempPortal))=execute
		x execute
	}
	q ret
}

/// Creator：     wuqk
/// CreatDate：   2014-1-15
/// Description:  根据ClassName:Query返回结果集,并拆分指定列,转换为xml输出
/// Table：       
/// Input：       clsName : 类名称
///               queryName : query名称
///               p1-p16 : 参数
/// Return：      
ClassMethod GetRecordSetDataSplit(clsName, queryName, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) As %Library.GlobalCharacterStream [ WebMethod ]
{
	set qdf=##class(%Dictionary.QueryDefinition).%OpenId(clsName_"||"_queryName)
	quit:'$IsObject(qdf) "Service:"_clsName_":"_queryName_" is not found."
	
	set paras=qdf.FormalSpec
	set:paras="" parasCount=0
	set:paras'="" parasCount=$l(paras,",")
	set rs=##class(%ResultSet).%New(clsName_":"_queryName)
	
	if parasCount=0 {d rs.Execute()}
	else{
		set execute="s sc=rs.Execute(",i=0
		set execute="set %sc=$zobjmethod(rs,""Execute"",",i=0
		while (i<parasCount){
			set i=i+1
			set execute=execute_"$g(p"_i_")"
			if (i<parasCount) {set execute=execute_","}
		}
		set execute=execute_")"
		s ^TempPortal($i(^TempPortal))=execute
		x execute
	}
	
	set obj=..%New()
	set obj.Source=rs
	do obj.WriteXml()
	quit obj.XmlStream
}

Method WriteXml(flag As %Integer = 0) As %Status
{
	d ..XmlStream.Write(..#XmlTitle)
	d ..WriteRootTag(..Source.QueryName)
	d:flag=0 ..WriteChildTagData()
	d:flag=1 ..WriteChildTagDataSplit()
	d ..EndRootTag()
	q 1
}

/// 写根标签
Method WriteRootTag(value = "") As %Status
{
	
	d ..XmlStream.Write("<data title="""_value_""">")
	
	q 1
}

/// 结束根标签
Method EndRootTag() As %Status
{
	
	d ..XmlStream.Write("</data>")
	
	q 1
}

/// 写子标签
/// tagFlag=0,开始标签,其他为结束标签
Method WriteChildTag(tagFlag = 0) As %Status
{
	
	q:tagFlag=0 ..XmlStream.Write("<item>")
	q ..XmlStream.Write("</item>")
}

/// 写子标签数据
Method WriteDataTag(name, value) As %Status
{
	;d ..XmlStream.Write("<set name=""a"" value=""1""/>" )
	
	d ..XmlStream.Write("<set name="""_name_""" value="""_value_"""/>" )
	;d ..XmlStream.Write("<"_name_">"_value_"</"_name_">" )
	
	q 1
}

/// 写子标签数据
/// 具体接口需要重写此方法
Method WriteChildTagData() As %Status
{
	While ..Source.Next() 
	{
		d ..WriteChildTag()
		f i=1:1:..Source.GetColumnCount()
		{
			d ..WriteDataTag(..Source.GetColumnName(i),..Source.%GetData(i))
		
		}
		d ..WriteChildTag(1) 
	}
	
	q 1
}

/// add by wuqk 
/// 2014-01-15
/// 拆分指定列——dimDesc
/// 写子标签数据
/// 具体接口需要重写此方法
Method WriteChildTagDataSplit() As %Status
{
	While ..Source.Next() 
	{
		d ..WriteChildTag()
		f i=1:1:..Source.GetColumnCount()
		{
			if (..Source.GetColumnName(i)="dimDesc"){
				 s d=..Source.%GetData(i)
				 s cnt=$l(d,",")
				 f n=1:1:cnt {
					 d ..WriteDataTag(dimDesc_n,$p(d,",",n))
				 }
			}
			else {d ..WriteDataTag(..Source.GetColumnName(i),..Source.%GetData(i))}			
		
		}
		d ..WriteChildTag(1) 
	}
	
	q 1
}

}

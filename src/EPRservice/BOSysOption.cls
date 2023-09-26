/// EPRservice.BOSysOption
Class EPRservice.BOSysOption Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "SysOptionInfo";

/// TODO: add arguments and implementation.
/// CreateSysOption
ClassMethod CreateSysOption(ASysOption As EPRservice.entity.ESysOption) As %String [ WebMethod ]
{
 TSTART
 set objSysOption = ##class(EPRmeta.SysOption).%New()
 Quit:(objSysOption ="") "ERROR"
 set UniqueFlag = ##class(EPRmeta.SysOption).CheckNameUnique(ASysOption.Name) 
 if '(UniqueFlag=0)
 { 
 Quit "-1"
 } 

 set objSysOption.Name = ASysOption.Name

 set objSysOption.Description = ASysOption.Description
 set objSysOption.OptionValue = ASysOption.OptionValue
 if (ASysOption.IsVisible = "")
 {
 	set ASysOption.IsVisible = "Y"	 
 }
 set objSysOption.IsVisible = ASysOption.IsVisible
 
 if '(objSysOption.%Save())
 {
 TROLLBACK
 Quit 0
 } 
 TCOMMIT
 Quit objSysOption.%Id()
}

/// TODO: add arguments and implementation.
/// DeleteSysOption
ClassMethod DeleteSysOption(AID As %String) As %Boolean [ WebMethod ]
{
 S ExistID =  ##class(EPRmeta.SysOption).CheckIdExist(AID)
 if (ExistID = 0) 
 { Quit 1
	  }
	set objSysOption = ##class(EPRmeta.SysOption).%OpenId(AID)
	Quit objSysOption.%DeleteId(AID)
}

ClassMethod GetValueByName(AName As %String) As %String [ WebMethod ]
{
 set Result =##class(EPRmeta.SysOption).GetOptionValueByName(AName)
 Quit Result
}

ClassMethod SelectAllSysOption() As EPRservice.dataset.ESysOptionDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.ESysOptionDataset).%New()
 Quit result
}

/// TODO: add arguments and implementation.
/// UpdateSysOption
ClassMethod UpdateSysOption(ASysOption As EPRservice.entity.ESysOption) As %String [ WebMethod ]
{
 set objSysOption = ##class(EPRmeta.SysOption).%OpenId(ASysOption.ID)

 S UniqueFlag=##class(EPRmeta.SysOption).CheckUpdateNameUnique(ASysOption.ID,ASysOption.Name)
 if '(UniqueFlag=0)
 { 
 Quit "-1"
 } 

 set objSysOption.Name = ASysOption.Name


 set objSysOption.Description = ASysOption.Description
 set objSysOption.OptionValue = ASysOption.OptionValue
 if '(objSysOption.%Save())
 {Quit "0"}
 Quit "1"
}

/// TODO: Update Value Indexed By Name Or Id 
ClassMethod UpdateSysOptionValue(ASysOption As EPRservice.entity.ESysOption) As %String [ WebMethod ]
{
 
 S sysOptionId = ""
 s sysOptionName = ASysOption.Name
 if ((ASysOption.ID = "") && (ASysOption.Name '= ""))
 {
 	&SQL(select ID into :sysOptionId From EPRmeta.SysOption Where Name = :sysOptionName)	 
 }
 s ASysOption.ID = sysOptionId
 q:(ASysOption.ID = "") "-1"
 
 set objSysOption = ##class(EPRmeta.SysOption).%OpenId(ASysOption.ID)

 S UniqueFlag=##class(EPRmeta.SysOption).CheckUpdateNameUnique(ASysOption.ID,ASysOption.Name)
 q:('(UniqueFlag=0)) "-1"

 set objSysOption.OptionValue = ASysOption.OptionValue
 if '(objSysOption.%Save())
 {Quit "0"}
 
 Quit "1"
}

/// OpenFristTemplate 参数为 Y/N/I^1#630#603!O^456 CG#prtDocId#tempDocId
/// w ##Class(EPRservice.BOSysOption).OpenFristTemplate(201871)
ClassMethod OpenFristTemplate(episodeID As %String) As %String
{
	s openFristTemplate = ##Class(EPRmeta.SysOption).GetOptionValueByName2("OpenFristTemplate","N")
	q:("Y"=openFristTemplate) "Y"
	q:("N"=openFristTemplate) "N"
	
	s ret="N"
	//病人就诊类型
	s AdmType = $p($g(^PAADM(episodeID)),"^",2)
	s iCount=$l(openFristTemplate,"!")
	for i=1:1:iCount
	{
		s type=$p($p(openFristTemplate,"!",i),"^",1)
		if (type=AdmType)
		{
			s ret = $p($p(openFristTemplate,"!",i),"^",2)
			Q
		}
	}
	
	q ret
}

}

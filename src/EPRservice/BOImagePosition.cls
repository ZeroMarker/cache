/// EPRservice.BOImagePosition
Class EPRservice.BOImagePosition Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ImagePositionInfo";

/// TODO: add arguments and implementation.
/// Testkkkkkk
ClassMethod CreateImagePosition(AEImagePosition As EPRservice.entity.EImagePosition) As %String [ WebMethod ]
{
	TSTART
	
	set objImagePosition = ##class(EPRmeta.ImagePosition).%New()
    set objImagePosition.Code = AEImagePosition.Code
    set objImagePosition.Name = AEImagePosition.Name
    set objImagePosition.Description = AEImagePosition.Description
    
    Do objImagePosition.Data.CopyFrom(AEImagePosition.Data)

 if '(objImagePosition.%Save())
 {
	  TROLLBACK
 Quit ""
	} 
 TCOMMIT
 Quit objImagePosition.%Id()
}

ClassMethod DeleteImagePosition(AID As %String) As %Boolean [ WebMethod ]
{
 TSTART
 set objImagePosition = ##class(EPRmeta.ImagePosition).%OpenId(AID)
 if (objImagePosition ="")
 { TROLLBACK
  Quit 0 } 
 if '(objImagePosition.%DeleteId(AID))
 { TROLLBACK
  Quit 0 } 
 TCOMMIT
 Quit 1
}

ClassMethod GetImagePositionByID(AID As %String) As EPRservice.entity.EImagePosition [ WebMethod ]
{
 set objImagePosition = ##class(EPRmeta.ImagePosition).%OpenId(AID)
 Q:(objImagePosition="") ""

 set Result = ##class(EPRservice.entity.EImagePosition).%New()
 Q:(Result="") ""

 set Result.ID = objImagePosition.%Id()
 set Result.Name = objImagePosition.Name
 set Result.Code = objImagePosition.Code
 set Result.Description = objImagePosition.Description
 Do Result.Data.CopyFrom(objImagePosition.Data)
 Quit Result
}

ClassMethod UpdateImagePosition(AEImagePosition As EPRservice.entity.EImagePosition) As %Boolean [ WebMethod ]
{
 TSTART
	
 set objImagePosition = ##class(EPRmeta.ImagePosition).%OpenId(AEImagePosition.ID)
 if objImagePosition=""
 { 
  TROLLBACK
  Quit 0}
 set objImagePosition.Name = AEImagePosition.Name
 set objImagePosition.Description = AEImagePosition.Description
 
 set objImagePosition.Code = AEImagePosition.Code
 Do objImagePosition.Data.CopyFrom(AEImagePosition.Data)

 if '(objImagePosition.%Save())
 {
   TROLLBACK
   Quit 0  }    
  TCOMMIT
  Quit 1
}

ClassMethod GetALLImagePosition() As EPRservice.dataset.EImagePositionDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EImagePositionDataset).%New()
 Do result.Execute()

 Quit result
}

ClassMethod GetImagePositionByCode(ACode As %String) As EPRservice.entity.EImagePosition [ WebMethod ]
{
 set AID = ##class(EPRmeta.ImagePosition).GetIdByCode(ACode)
 if (AID ="")
 {
	Quit "" 
	 }
 elseif (AID '="")
 {
 set objImagePosition = ##class(EPRmeta.ImagePosition).%OpenId(AID)
 Q:(objImagePosition="") ""

 set Result = ##class(EPRservice.entity.EImagePosition).%New()
 Q:(Result="") ""

 set Result.ID = objImagePosition.%Id()
 set Result.Name = objImagePosition.Name
 set Result.Code = objImagePosition.Code
 set Result.Description = objImagePosition.Description
 Do Result.Data.CopyFrom(objImagePosition.Data)
 Quit Result
	 }
}

ClassMethod Test1()
{
   /*set aa=##class(EPRservice.entity.EImagePosition).%New()
   set aa.Code ="ppp" 	 
   set aa.ID ="5" 	 
   set aa.Description ="ppp" 	 
   set aa.Name ="ppp" 	 
   d aa.Data.Write("nbnb")
   d ##class(EPRservice.BOImagePosition).CreateImagePosition(aa)*/
    set ii= ##class(EPRservice.BOImagePosition).DeleteImagePosition("7")
	 w ii
}

}

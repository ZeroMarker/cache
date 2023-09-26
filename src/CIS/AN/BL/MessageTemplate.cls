Class CIS.AN.BL.MessageTemplate Extends %RegisteredObject
{

ClassMethod SaveMessageTemplate(jsonData As %DynamicObject, updateUserID As %String) As %String
{
  set ^TMPCCQ("MsgTemplate")=jsonData.%ToJSON()
  set $zt="Error"
  //set jsonData=##class(%DynamicObject).%FromJSON(jsonStr)
  set messageTemplate=""
  if (##class(CF.AN.MessageTemplate).%ExistsId(jsonData.RowId))
  {
    set messageTemplate=##class(CF.AN.MessageTemplate).%OpenId(jsonData.RowId)
  }
  else
  {
    set messageTemplate=##class(CF.AN.MessageTemplate).%New()
  }
  set messageTemplate.DeptID=jsonData.DeptID
  set messageTemplate.OperID=jsonData.OperID
  set messageTemplate.MessageText=jsonData.MessageText
  set:('##class(CF.AN.MessageTemplate).%ExistsId(jsonData.RowId)) messageTemplate.CreateUserID=updateUserID
  set messageTemplate.UpdateUserID=updateUserID
  set messageTemplate.UpdateDate=+$h
  set messageTemplate.UpdateTime=$p($h,",",2)
  set messageTemplate.Active=jsonData.Active
  set messageTemplate.MessageDesc=jsonData.MessageDesc 
  set messageTemplate.Status="N"
  set sc=messageTemplate.%Save()
  quit:($SYSTEM.Status.IsError(sc)) "E^"_$SYSTEM.Status.GetErrorText(sc)
  quit "S^"_messageTemplate.%Id()
Error
  quit "E^"_$ze
}

ClassMethod DelMessageTemplate(dataRowId As %String, updateUserID As %String) As %String
{
  set $zt="Error"
  set messageTemplate=##class(CF.AN.MessageTemplate).%OpenId(dataRowId)
  set messageTemplate.Status="D"
  set messageTemplate.UpdateUserID=updateUserID
  set messageTemplate.UpdateDate=+$h 
  set messageTemplate.UpdateTime=$p($h,",",1)
  set sc=messageTemplate.%Save()
  quit:($SYSTEM.Status.IsError(sc)) "E^"_$SYSTEM.Status.GetErrorText(sc)
  quit "S^"
Error
  quit "E^"_$ze
}

/// 获取短信模板
/// w ##class(CIS.AN.BL.MessageTemplate).GetMessageTemplate("881","")
ClassMethod GetMessageTemplate(deptId As %String, operId As %String = "") As %String
{
  set messageText=""
  &sql(select MessageText into :messageText from CF_AN.MessageTemplate 
    where DeptID=:deptId
    and (:operId is null or OperID=:operId)
    and Active='Y' 
    and Status='N')
  if (messageText="") d
  .&sql(select MessageText into :messageText from CF_AN.MessageTemplate 
    where (DeptID is null)
    and (:operId is null or OperID=:operId)
    and Active='Y'
    and Status='N')
  quit messageText
}

ClassMethod GetMessageTemplates(deptId As %String, content As %String, active As %String, createDate As %String) As %String
{
  set createDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(createDate,"")
  &sql(declare TemplateCursor cursor for select RowId,%External(Active) into :TemplateID,:ActiveDesc
      from CF_AN.MessageTemplate
      where (DeptID=:deptId or :deptId is null)
      and (MessageText [ :content or :content is null)
      and (Active=:active or :active is null)
      and (CreateDate=:createDateH or :createDate is null)
      and (Status='N' or Status is null))

  &sql(open TemplateCursor)
  set templateList=##class(%DynamicArray).%New()
  for 
  {
    &sql(fetch TemplateCursor)
    quit:(SQLCODE'=0)
    set message=##class(CF.AN.MessageTemplate).%OpenId(TemplateID)
    set template=##class(%DynamicObject).%New()
    set template.RowId=TemplateID
    set template.DeptID=message.DeptID
    set template.DeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",message.DeptID)
    set:template.DeptDesc="" template.DeptDesc="公共模板"
    set template.OperID=message.OperID
    set template.OperDesc=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERDesc",message.OperID)
    set template.Active=message.Active
    set template.ActiveDesc=ActiveDesc
    set template.MessageText=message.MessageText
    set template.CreateUserID=message.CreateUserID
    set template.CreateUserDesc=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",message.CreateUserID)
	set DateFormat=$lg(^websys.ConfigurationD(1),10)
	if ((DateFormat="DMY")&&(message.CreateDate'="")) set template.CreateDate=$zd(message.CreateDate,4) 
    else  set template.CreateDate=##class(CIS.AN.COM.DateTime).ConvertToDate(message.CreateDate)
    set template.MessageDesc=message.MessageDesc
    do templateList.%Push(template)
  }
  &sql(close TemplateCursor)

  quit templateList.%ToJSON()
}

}

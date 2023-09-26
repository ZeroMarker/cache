Import SQLUser

Class web.DHCEMIMPCOMMON Extends %RegisteredObject [ ProcedureBlock ]
{

/// Description：添加码表数据日志
/// Creator:     yangyongtao
/// CreatDate:   2017-03-03
/// Table：BDP_DataChangeLog
/// Other: d ##class(web.DHCEMIMPCOMMON).SaveLog("","","","","","U","")
ClassMethod SaveLog(TableName As %String, ClassName As %String, ClassNameDesc As %String, ObjectReference As %String, ObjectDesc As %String, OperateType As %String, NewValue As %String, OldValue As %String = "") As %String
{
 s result=""
 if (TableName="") {
  s result="表名不能为空!"
 }elseif(ClassName="") {
  s result="类名不能为空!"
 }elseif(ObjectReference="") {
  s result="对象ID不能为空!"
 }elseif(OperateType="") {
  s result="修改类型不能为空!"
 }elseif '$d(%session) {
  s result="获取不到session!"
 }else {
  Ts
  s obj=##class(User.BDPDataChangeLog).%New()
  s obj.TableName = TableName
  s obj.ClassName = ClassName
  s obj.ClassNameDesc = ClassNameDesc    //类描述
  s obj.ObjectReference = ObjectReference
  s obj.ObjectDesc = ObjectDesc  //对象描述
  s obj.IpAddress = $Get(%session.Data("REMOTE_ADDR"))
  d obj.UpdateUserDRSetObjectId($Get(%session.Data("LOGON.USERID")))
  s obj.UpdateUserName = $Get(%session.Data("LOGON.USERNAME"))
  s obj.OperateType = OperateType  
  s:NewValue'="" obj.NewValue = NewValue.JsonS()
  s:OldValue'="" obj.OldValue = OldValue.JsonS()
  
  s sc=obj.%Save()
  d obj.%Close()
  If $$$ISOK(sc) {
   Tc
   s result="添加成功!"
  }else {
   Trollback
   s result="添加失败!"
  }
 }
 q result
}

}

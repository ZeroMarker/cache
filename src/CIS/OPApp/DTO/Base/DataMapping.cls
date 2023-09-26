Class CIS.OPApp.DTO.Base.DataMapping Extends (CIS.OPApp.DTO.Abstract.Arguments, CIS.OPApp.DTO.Abstract.Model)
{

/// 数据表
Property TableName As %String;

/// 实例ID
Property InstanceID As %String;

/// 外部系统(OPApp,AIS,HIS,LIS,PIS)
Property ExternalSystem As %String;

/// 外部ID
Property ExternalID As %String;

/// 是否有效
Method Validate() As %Boolean
{
	quit (##this.TableName'="")&&(##this.ExternalSystem'="")&&(##this.ExternalID'="")&&(##this.InstanceID'="")
}

}

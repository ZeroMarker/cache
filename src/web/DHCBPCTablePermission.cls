Class web.DHCBPCTablePermission Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCTablePermission","FindTablePermission")
Query FindTablePermission() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
       BPCTab_Name As TableName,
	   BPCTab_Desc As TableDesc,
	   BPCTab_Permission As Permission,
	   %External(BPCTab_Permission) As PermissionDesc
	   from SQLUSER.DHC_BPC_TablePermission
}

/// 判断类的多院区权限类型是否为私有
/// w ##class(web.DHCBPCTablePermission).IsPrivate("User.PacBed")
ClassMethod IsPrivate(className As %String) As %Boolean
{
        set result=0
        set rowId=$o(^User.DHCBPCTablePermissionI("IPermission"," "_$ZCVT(className,"U")," PRIVATE",""))
        if rowId>0 set result=1
        
        quit result
}

/// 判断是否已绑定了权限归属，只考虑私有的情况
/// w ##class(web.DHCBPCTablePermission).HasBindedAttribution("User.PacBed",17)
ClassMethod HasBindedAttribution(className, rowId) As %Boolean
{
	set attributionId=$o(^User.DHCBPCDataAttributionI("IData"," "_$ZCVT(className,"U")," "_rowId,""))
	quit $s(attributionId>0:1,1:0)
}

/// 创建数据权限归属
ClassMethod CreateAttribution(className, rowId, hospId, ByRef message) As User.DHCBPCDataAttribution
{
	set attribution = ##class(User.DHCBPCDataAttribution).%New()
	set attribution.HospitalID = hospId
	set attribution.TableName = className
	set attribution.DataRowID = rowId
	
	set sc=attribution.%Save()
	if $$$ISERR(sc)
	{
		set message="E^"_$System.Status.GetErrorText(sc,"zh-cn")
	}
	else
	{
		set message="S^"
	}
	
	quit attribution
}

/// 绑定数据权限
/// d ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPBedEquip",3,2)
ClassMethod BindAttribution(className, rowId, hospId) As %String
{
	set result= "S^"
	if ((hospId>0)&&('..HasBindedAttribution(className, rowId)))
	{
		set instance=""
        if ($classmethod(className,"%ExistsId",rowId)=1)
        {
            set instance=$classmethod(className,"%OpenId",rowId)
            set $property(instance,"DataAttribution")=..CreateAttribution(className, rowId, hospId,.message)
            if ($e(message,1)="E")
            {
                set result=message
            }
            else
            {
            	set sc=$method(instance,"%Save")
            	if ($System.Status.IsOK(sc))
            	{
                	set result="S^"_$method(instance,"%Id")
            	}
            	else
            	{
                	set result="E^"_$System.Status.GetErrorText(sc) // 获取错误详细信息(语言使用中文)
            	}
            }
      	}
	}
    quit result
}

/// 取消绑定数据权限归属
ClassMethod UnbindAttribution(className, rowId) As %String
{
	set result="S^"
	if (..HasBindedAttribution(className, rowId))
	{
		set attributionId=$o(^User.DHCBPCDataAttributionI("IData"," "_$ZCVT(className,"U")," "_rowId,""))
		if (##class(User.DHCBPCDataAttribution).%ExistsId(attributionId))
		{
			set sc = ##class(User.DHCBPCDataAttribution).%DeleteId(attributionId)
			if ($System.Status.IsOK(sc))
        	{
            	set result="S^"
        	}   
        	else
        	{
            	set result="E^"_$System.Status.GetErrorText(sc,"zh-cn") 
        	}
		}
	}
	
	quit result
}

}

/// 名称:EMRservice.BL.BLTemplateContrast
/// 名称: 病历模板对比数据项维护BL层
/// 描述: 病历模板对比数据项维护
/// 编写者：yejian
/// 编写日期: 2018-5-28
Class EMRservice.BL.BLTemplateContrast Extends (%RegisteredObject, %XML.Adaptor)
{

/// 根据模板ID和版本获取配置项
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLContrastItem","GetContrastItemByTID","1")
Query GetContrastItemByTID(aTemplateID As %String, aVersionID As %String) As %Query(ROWSPEC = "ID:%Integer,TemplateID:%String,TemplateVersion:%String,PathCode:%String,ItemCode:%String,Author:%String,LastSaveDate:%String")
{
}

ClassMethod GetContrastItemByTIDExecute(ByRef qHandle As %Binary, aTemplateID As %String, aVersionID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(($g(aTemplateID) = "")||(aTemplateID=$c(0))) $$$OK
	q:(($g(aVersionID) = "")||(aVersionID=$c(0))) $$$OK
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.TemplateContrastI("IndexTemplateVersion"," "_aTemplateID," "_aVersionID,rowID))
		q:(rowID = "")
		s objContrastItem = ##Class(EMRmeta.TemplateContrast).%OpenId(rowID)
		continue:(objContrastItem = "")
	
		s TemplateID = objContrastItem.TemplateID
		s TemplateVersion = objContrastItem.TemplateVersion
		s PathCode = objContrastItem.PathCode
		S ItemCode = objContrastItem.ItemCode
		s Author = objContrastItem.Author
		s LastSaveDate = $ZDATE(objContrastItem.LastSaveDate,3)
	
		s Data = $lb(rowID,TemplateID,TemplateVersion,PathCode,ItemCode,Author,LastSaveDate)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
		
	}
	
	q $$$OK
}

ClassMethod GetContrastItemByTIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContrastItemByTIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetContrastItemByTIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContrastItemByTIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 添加数据项
ClassMethod GetTemplateContrast(Aid As %String) As EMRservice.entity.ETemplateContrast
{
	q:(($g(Aid) = "")||(Aid=$c(0))) ""
	s objContrastItem = ##Class(EMRmeta.TemplateContrast).%OpenId(Aid)
	q:(objContrastItem = "") ""
	s AContrastItem = ##Class(EMRservice.entity.ETemplateContrast).%New()
	s AContrastItem.TemplateID = objContrastItem.TemplateID
	s AContrastItem.TemplateVersion = objContrastItem.TemplateVersion
	s AContrastItem.PathCode = objContrastItem.PathCode
	s AContrastItem.ItemCode = objContrastItem.ItemCode
	s AContrastItem.Author = objContrastItem.Author
	s AContrastItem.LastSaveDate = $ZDATE(objContrastItem.LastSaveDate,3)
	d AContrastItem.Text.CopyFrom(objContrastItem.Text)
	q AContrastItem
}

/// 添加数据项
ClassMethod AddContrastItem(AContrastItem As EMRservice.entity.ETemplateContrast) As %String
{
	s ret = 0
	s rowID = $o(^DHCEMRM.TemplateContrastI("IndexTemVerPCode"," "_AContrastItem.TemplateID," "_AContrastItem.TemplateVersion," "_$zcvt(AContrastItem.PathCode,"U"),""))
	s objContrastItem = ##Class(EMRmeta.TemplateContrast).%New()
	if (rowID ="")
	{
		s objContrastItem.TemplateID = AContrastItem.TemplateID
		s objContrastItem.TemplateVersion = AContrastItem.TemplateVersion
		s objContrastItem.PathCode = AContrastItem.PathCode
		s objContrastItem.ItemCode = AContrastItem.ItemCode
		s objContrastItem.Author = AContrastItem.Author
		s objContrastItem.isValid ="1"
		s objContrastItem.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
		d objContrastItem.Text.CopyFrom(AContrastItem.Text)
	}
	else
	{
		s objContrastItem = ##Class(EMRmeta.TemplateContrast).%OpenId(rowID)
		s objContrastItem.TemplateID = AContrastItem.TemplateID
		s objContrastItem.TemplateVersion = AContrastItem.TemplateVersion
		s objContrastItem.PathCode = AContrastItem.PathCode
		s objContrastItem.ItemCode = AContrastItem.ItemCode
		s objContrastItem.Author = AContrastItem.Author
		s objContrastItem.isValid ="1"
		s objContrastItem.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
		d objContrastItem.Text.CopyFrom(AContrastItem.Text)
	}
	if (objContrastItem.%Save())
	{
	    s ret=objContrastItem.%Id()
	    s ret=1
	}
	else
	{
	   s ret=0
	}		
	d objContrastItem.%Close()
	
	q ret
}

/// 添加数据项（根据版本）
/// aTemplateID:模板ID，aOVersion：旧版本号，aNVersion，新版本号
ClassMethod AddContrastItemByVersion(aTemplateID As %String, aOVersion As %String, aNVersion As %String) As %String
{
	s res ="0"
	q:((aOVersion="")||(aNVersion="")||(aTemplateID="")) res
	q:((aOVersion=$c(0))||(aNVersion=$c(0))||(aTemplateID=$c(0))) res
	
	s arowID = ""
	for {
		s arowID = $o(^DHCEMRM.TemplateContrastI("IndexTemplateVersion"," "_aTemplateID," "_aOVersion,arowID))
		q:(arowID = "")	
		s oldContrastItem = ##Class(EMRmeta.TemplateContrast).%OpenId(arowID)
		//如果没有,则新增;有则不处理
		s objContrastItem = ##class(EMRmeta.TemplateContrast).%New()
		
		s objContrastItem.TemplateID = oldContrastItem.TemplateID
		s objContrastItem.TemplateVersion = aNVersion
		s objContrastItem.PathCode = oldContrastItem.PathCode
		s objContrastItem.ItemCode = oldContrastItem.ItemCode
		s objContrastItem.Author = oldContrastItem.Author
		s objContrastItem.isValid ="1"
		s objContrastItem.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
		d objContrastItem.Text.CopyFrom(oldContrastItem.Text)
		s sc =objContrastItem.%Save()
		if ($$$ISOK(sc))
		{
			s res = objContrastItem.%Id()
		}
		d oldContrastItem.%Close()
		d objContrastItem.%Close()
		s objContrastItem = ""
			
	}
		
	//返回
	q res
}

/// 修改数据项
ClassMethod ModContrastItem(AContrastItem As EMRservice.entity.ETemplateContrast) As %String
{
	s ret = 1

	s objContrastItem = ##Class(EMRmeta.TemplateContrast).%OpenId(AContrastItem.ID)
	s objContrastItem.Author = AContrastItem.Author
	s objContrastItem.LastSaveDate = AContrastItem.LastSaveDate
	d objContrastItem.Text.CopyFrom(AContrastItem.Text)
	if (objContrastItem.%Save())
	{
	    s ret=objContrastItem.%Id()
	}
	else
	{
	   s ret=0
	}		

	d objContrastItem.%Close()
	q ret
}

/// 设为无效
ClassMethod Delete(RowID As %String) As %String
{
	s ret = 0
	q:(RowID="") ret
	//原有数据进行“删除”,将数据ActiveFlag设置为0
	s sc = ##class(EMRmeta.TemplateContrast).%DeleteId(RowID)
	if ($$$ISOK(sc))
	{
		s ret = 1
	}
	q ret
}

}

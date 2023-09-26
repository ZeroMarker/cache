/// Desc：病历查询字典
/// creator：candy
Class DHCEPRFS.Srv.SrvQueryDic Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvQueryDic";

/// Desc: 获取所有医生
/// Creator:Candy
ClassMethod Doctor() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.HISInfo.BLDictionaryInfo:Doctor")
	d obj.SetArgs()
	q obj
}

ClassMethod Ward() As %XML.DataSet [ WebMethod ]
{
	s obj = ##class(%XML.DataSet).%New("DHCEPRFS.BL.HISInfo.BLDictionaryInfo:Ward")
	d obj.SetArgs()
	q obj
}

/// Desc: 获取所有科室
/// Creator:Candy
ClassMethod AdmLoc() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.HISInfo.BLDictionaryInfo:CTLoc")
	d obj.SetArgs()
	q obj
}

/// Desc:获取所有自定义字典
ClassMethod GetAllCustomDic() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLCustomDic:GetAllDic")
	d obj.SetArgs()
	q obj
}

/// Desc:获取字典分类目录
ClassMethod GetCateDic() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLCustomDic:GetCateDic")
	d obj.SetArgs()
	q obj
}

/// Desc:根据分类目录ID获取分类项
ClassMethod GetFieldByCateDicID(ACateDicID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLCustomDic:GetFieldByCateDicID")
	d obj.SetArgs(ACateDicID)
	q obj
}

/// Desc:根据类名称和方法名获取其值
ClassMethod GetFiledValues(AClassName As %String, AParam As %String) As %XML.DataSet [ WebMethod ]
{
	s:(AClassName = $c(0)) AClassName = ""
	s:(AParam = $c(0)) AParam = "" 
	q:(AClassName = "") ""
    s obj = ##Class(%XML.DataSet).%New(AClassName)
    if (AParam = "")
    {
        d obj.SetArgs()
    }else
    {
	    d obj.SetArgs(AParam)
	}
    q obj
}

/// Desc: 从归档基础码表获取所有科室
/// Creator:Candy
ClassMethod GetAllLocByType(ACTLocType As %String) As %XML.DataSet [ WebMethod ]
{
	s:(ACTLocType =$c(0)) ACTLocType = ""
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetAllLocByType")
	d obj.SetArgs(ACTLocType)
	q obj
}

/// Desc:取得所有性别
ClassMethod GetAllGender() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLCustomDic:GetCustomDicByType")
	d obj.SetArgs("Gender")
	q obj
}

/// Desc:按照类别获取自定义字典项目
ClassMethod GetCustomDicByType(AType As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLCustomDic:GetCustomDicByType")
	d obj.SetArgs(AType)
	q obj
}

}

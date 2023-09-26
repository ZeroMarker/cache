/// Creator:         wk
/// CreatDate:       2018-01-11
/// Description:	 版本管理
Class web.DHCWL.V1.VerManagement.VerManagement Extends %RegisteredObject
{

/// Creator：      wk
/// CreatDate：    2018-01-11
/// Description:： 版本管理产看历史信息
/// Table：        
/// Input：       产品对应的ID
/// Output：      产品维护历史信息
/// Return：      
/// Others：w ##class(web.DHCWL.V1.VerManagement.VerManagement).CheckHisVerInfor(ID)
/// 
ClassMethod CheckHisVerInfor(ID) As %String
{
	q:ID="" ""
	s json=##class(DHCWL.util.UniteQueryData).GetJsonFromQuery("DHCWL.VerManagement.DefaultInOutService:GetHisByRowID","",ID)
	i json="" {
		w "{result:0,totalNum:0,root:[]}"
		q
	}
	s jsonHead=json.GetHead()
	w jsonHead
	d{
		s obj=json.Next()
		w obj
	}while(obj'="")
	i json.GetCount()=0 w "]}"
	q ""
}

}

Class EPRservice.BLL.Query.BLSaveQueryCaseInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Desc：   保存方案名称，先检查方案名称是否存在;
/// Return： -1：保存失败or名称为空(前台已限制); -2: 名称已存在; >0的整数 : 保存成功
/// Input：  CaseNameObj：方案名称对象，包含以下属性：
/// 		 curCaseID：  当前方案ID;若是保存新方案curCaseID=“SaveNewCase”，若是修改后保存curCaseID为被修改的方案ID
/// 		 CaseName：   方案名称
/// 		 UserID：     保存者ID
/// 		 UserName：   保存者姓名
/// 		 CTLocIDStr： 此方案的可见科室ID串
/// 		 GroupIDStr： 此方案的可见安全组ID串
ClassMethod SaveCaseName(curCaseID As %String, CaseNameObj As EPRservice.entity.Query.EQueryCaseName)
{
	s return=-1
	Quit:(CaseNameObj.Name="") return
	
	s Existed = -2
	s IsExist = ##Class(EPRservice.DAL.Query.DAQueryCaseInfo).CheckCaseName(curCaseID,CaseNameObj)
	if IsExist=1
	{
		Quit Existed
	}
	else 
	{
		if (curCaseID="SaveNewCase")
		{
			s return = ##Class(EPRservice.DAL.Query.DAQueryCaseInfo).AddCaseName(CaseNameObj)
		}
		elseif (curCaseID>0)
		{
			s return = ##Class(EPRservice.DAL.Query.DAQueryCaseInfo).SaveCaseName(curCaseID,CaseNameObj)
		}
	}
	
	Quit return
}

/// 将字符串分解成查询条件信息,并保存
ClassMethod SaveCondition(ConditionStr As %String, CaseID As %String)
{
	s return=-1
	Quit:(CaseID="") return
	
	s i=1,j=2,k=3,m=4,n=5,count=0
	for {
		s ORCode = $p(ConditionStr,",",i)
		s ItemCode = $p(ConditionStr,",",j)
		Quit:(ItemCode="")
		s ItemName = $p(ConditionStr,",",k)
		Quit:(ItemName="")
		s OPCode = $p(ConditionStr,",",m)
		s txtValue = $p(ConditionStr,",",n)
		
		s ConditionObj = ##class(EPRservice.entity.Query.EQueryCaseCondition).%New()
		s ConditionObj.ORCode = ORCode
		s ConditionObj.ItemCode = ItemCode
		s ConditionObj.ItemName = ItemName
		s ConditionObj.OPCode = OPCode
		s ConditionObj.txtValue = txtValue
		s ConditionObj.CNId = CaseID
	
		d ##Class(EPRservice.DAL.Query.DAQueryCaseInfo).AddCondition(ConditionObj)
		s i=i+5,j=j+5,k=k+5,m=m+5,n=n+5
		s count=count+1
		}
	Quit count
}

/// 将字符串分解成结果列信息,并保存
ClassMethod SaveResultCols(ResultColsStr As %String, CaseID As %String)
{
	s return=-1
	Quit:(CaseID="") return
	
	s i=1,j=2,k=3,count=0
	for {
		s IsDisabled = $p(ResultColsStr,",",i)
		s ResultColsName = $p(ResultColsStr,",",j)
		Quit:(ResultColsName="")
		s ResultColsCode = $p(ResultColsStr,",",k)
		Quit:(ResultColsCode="")
		
		s ResultColsObj = ##class(EPRservice.entity.Query.EQueryCaseResultCols).%New()
		s ResultColsObj.IsDisabled = IsDisabled
		s ResultColsObj.ColsName = ResultColsName
		s ResultColsObj.ColsCode = ResultColsCode
		s ResultColsObj.CNId = CaseID
		
		d ##Class(EPRservice.DAL.Query.DAQueryCaseInfo).AddResultCols(ResultColsObj)
		s i=i+3,j=j+3,k=k+3
		s count=count+1
		}
	Quit count
}

}

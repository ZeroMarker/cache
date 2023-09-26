/// 名称: DHCMed.CCService.SubAppColsSrv
/// 描述: 公用方法
/// 编写者：zhufei
/// 编写日期: 2010-05-31
Class DHCMed.CCService.SubAppColsSrv Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-05-31
/// Description:  根据监控主题代码取展现方式对应的类/方法/表头设置
/// Table：       DHCMed.CC.SubjectAppCols
/// Input：       appcode:    DHCMed.CC.SubjectApp.Code
/// Return：      返回 return
/// w ##class(DHCMed.CCService.SubAppColsSrv).GetGridHeader("CC")
ClassMethod GetGridHeader(appcode As %String) As %String
{
	New (appcode)
	Set return=""
	
	Set objApp=##class(DHCMed.CC.SubjectApp).GetObjByCode(appcode)
	Quit:objApp="" ret
	Set AppID=objApp.%Id()
	Quit:AppID="" ret
	Set ShowDicID=objApp.SAShowDr
	Set objSubDic=##class(DHCMed.CC.ShowDic).GetObjById(ShowDicID)
	Quit:objSubDic="" return
	Set ClassName=$p(objSubDic.SDQueryName,":",1)
	Set QueryName=$p(objSubDic.SDQueryName,":",2)
	Quit:(ClassName="")||(QueryName="") return
	
	//取列设置
	Set rowSpec=""
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
 	Set count = cdef.Queries.Count()
 	For ind=1:1:count
 	{
	 	If (cdef.Queries.GetAt(ind).Name=QueryName)
	 	{
		 	Set rowSpec=cdef.Queries.GetAt(ind).Parameters.GetAt("ROWSPEC")
		}
	}
	Do cdef.%Close()
	Quit:rowSpec="" return
	
	Set GridHeader="var colModel = new Ext.grid.ColumnModel(["_$c(13)_$c(10)
 	Set displayCnt=0
	If $d(^DHCMed.CC.SubjectAppD(AppID,"ChildAppCols"))
	{
		Set ColHeaders=""
		For Ind=1:1:$l(rowSpec,",")
		{
			Set ColHeader=$p(rowSpec,",",Ind)
			Set ColHeader=$p(ColHeader,":",1)
			Set ColHeaders=ColHeaders_$lb(ColHeader)
		}
		
		//^DHCMed.CC.SubjectAppColsI("IndexSort",1," 01",1)
		Set Index=""
		For {
			Set Index=$o(^DHCMed.CC.SubjectAppColsI("IndexSort",AppID,Index))
			Quit:Index=""
			Set ChildID=0
			For {
				Set ChildID=$o(^DHCMed.CC.SubjectAppColsI("IndexSort",AppID,Index,ChildID))
				Quit:ChildID=""
				Set ID=AppID_"||"_ChildID
				Set objAppCols=##Class(DHCMed.CC.SubjectAppCols).GetObjById(ID)
				Continue:objAppCols=""
				Continue:objAppCols.SACName=""
				Continue:'$ListFind(ColHeaders,objAppCols.SACName)
				Set ColName=objAppCols.SACName
				Continue:ColName=""
				Set ColTitle=objAppCols.SACDesc
				Set:ColTitle="" ColTitle=ColName
				Set ColIsHide=objAppCols.SACIsHide
				Continue:ColIsHide'=0
				Set ColWidth=+objAppCols.SACWidth
				Set ColIsSort=$s(objAppCols.SACIsSort=0:"false",1:"true")
				Set:displayCnt>0 GridHeader=GridHeader_","
				Set GridHeader=GridHeader_"{header: '"_ColTitle_"',width: "_ColWidth_",dataIndex: '"_ColName_"', sortable: "_ColIsSort_"}"_$c(13)_$c(10)
				Set displayCnt=displayCnt+1
			}
		}
	}
	If displayCnt=0 {
		For Ind=1:1:$l(rowSpec,",")
		{
			Set ColHeader=$p(rowSpec,",",Ind)
			Set ColName=$p(ColHeader,":",1)
			Continue:ColName=""
			Set ColTitle=$p(ColHeader,":",3)
			Set:ColTitle="" ColTitle=ColName
			Set ColWidth=80
			Set ColIsSort="false"
			Set:displayCnt>0 GridHeader=GridHeader_","
			Set GridHeader=GridHeader_"{header: '"_ColTitle_"',width: "_ColWidth_",dataIndex: '"_ColName_"', sortable: "_ColIsSort_"}"_$c(13)_$c(10)
			Set displayCnt=displayCnt+1
		}
	}
	Set GridHeader=GridHeader_"]);"
	
	Set return=ClassName_$c(1)_QueryName_$c(1)_GridHeader
	Quit return
}

}

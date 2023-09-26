/// 名称: DHCMed.CCService.Sys.CtrlProcess
/// 描述: 监控中心监控解析主题程序
/// 编写者：zhufei
/// 编写日期: 2011-03-11
Class DHCMed.CCService.Sys.CtrlProcess Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-03-11
/// Description:  监控解析主题程序
/// Table：       
/// Input：       Paadm: 就诊号
/// 
///               SubjectID：监控主题ID
///               CtrlItems: 监控项目字符串
/// 
/// Return：      返回监控结果
/// w ##class(DHCMed.CCService.Sys.CtrlProcess).Main(Paadm)
ClassMethod Main(argPaadm As %String) As %List
{
	New (argPaadm,%ZIndex,%JIndex)
	Set return=""
	Quit:argPaadm="" return
	Quit:(%ZIndex="")||(%JIndex="") return
	Quit:'$d(^TMP(%ZIndex,%JIndex,"DHCMedCCExpList")) return
	
	Set $ZT="MainErr"
	
	Set %EpisodeID=argPaadm
	Set %PatientID=$p($g(^PAADM(argPaadm)),"^",1)
	
	Set ItemID=0,CtrlResult=0
	For {
		Set ItemID=$o(^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",1,ItemID))
		Quit:ItemID=""
		Set CtrlResult=CtrlResult+1
		Set strResult=##class(DHCMed.CCService.Sys.ExamExpress).Main(ItemID)
		Continue:strResult=""
		Continue:$li(strResult,3)<1
		Set CtrlResult=CtrlResult-1
		Set return=return_$lb(strResult)
	}
	Set:CtrlResult>0 return=""
	Quit:CtrlResult>0 return
	
	Set ItemID=0
	For {
		Set ItemID=$o(^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",0,ItemID))
		Quit:ItemID=""
		Set strResult=##class(DHCMed.CCService.Sys.ExamExpress).Main(ItemID)
		Continue:strResult=""
		Continue:$li(strResult,3)<1
		Set return=return_$lb(strResult)
	}
	
	Quit return
	
MainErr
	//Write "Error:"_$ZERROR,!
	Quit ""
}

/// w ##class(DHCMed.CCService.Sys.CtrlProcess).getCtrlItems(2)
ClassMethod getCtrlItems(argSubjectID As %String) As %String
{
	New (argSubjectID)
	Set return=""
	Quit:argSubjectID="" return
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"GetCtrlItems")
	Set SubjectID=0
	For {
		Set SubjectID=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID))
		Quit:SubjectID=""
		Continue:argSubjectID'=SubjectID
		Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
		Continue:'$IsObject(objSubject)
		Set IsActive=""
		For {
			Set IsActive=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID,IsActive))
			Quit:IsActive=""
			Continue:IsActive'=1  //1有效,0无效
			Set ItemID=0
			For {
				Set ItemID=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID,IsActive,ItemID))
				Quit:ItemID=""
				Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
				Continue:'$IsObject(objItem)
				Set ItemDicDR=objItem.ItemDic
				Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicDR)
				Continue:'$IsObject(objItemDic)
				Set ItemSubCatDR=objItemDic.IDSubCatDr
				Set objItemSubcat=##class(DHCMed.CC.ItemSubCat).GetObjById(ItemSubCatDR)
				Continue:'$IsObject(objItemSubcat)
				Set ItemCatDR=objItemSubcat.ISCCatDr
				Set ^TMP(ZIndex,JIndex,"GetCtrlItems",SubjectID,ItemCatDR,ItemSubCatDR,ItemDicDR,ItemID)=""
			}
		}
	}
	
	Set SubjectID=0
	For {
		Set SubjectID=$o(^TMP(ZIndex,JIndex,"GetCtrlItems",SubjectID))
		Quit:SubjectID=""
		Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
		Continue:'$IsObject(objSubject)
		
		Set CategID=0
		For {
			Set CategID=$o(^TMP(ZIndex,JIndex,"GetCtrlItems",SubjectID,CategID))
			Quit:CategID=""
			Set objCateg=##class(DHCMed.CC.ItemCat).GetObjById(CategID)
			Continue:'$IsObject(objCateg)
			
			Set SubCatID=0
			For {
				Set SubCatID=$o(^TMP(ZIndex,JIndex,"GetCtrlItems",SubjectID,CategID,SubCatID))
				Quit:SubCatID=""
				Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
				Continue:'$IsObject(objSubCat)
				
				Set ItemDicID=0
				For {
					Set ItemDicID=$o(^TMP(ZIndex,JIndex,"GetCtrlItems",SubjectID,CategID,SubCatID,ItemDicID))
					Quit:ItemDicID=""
					Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicID)
					Continue:'$IsObject(objItemDic)
					Set ItemID=$o(^TMP(ZIndex,JIndex,"GetCtrlItems",SubjectID,CategID,SubCatID,ItemDicID,0))
					Set return=return_"/"_ItemID
				}
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"GetCtrlItems")
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// w ##class(DHCMed.CCService.Sys.CtrlProcess).GetDHCMedCCExpList("1","")
ClassMethod GetDHCMedCCExpList(argSubjectID As %String, argCtrlItems As %String) As %String
{
	New (argSubjectID,argCtrlItems,%ZIndex,%JIndex)
	Set return=0,Count=0
	
	Set:$g(%ZIndex)="" %ZIndex=$zn
	Set:$g(%JIndex)="" %JIndex=$j
	
	Kill ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList")
	
	If argCtrlItems="" {
		Set argCtrlItems=..getCtrlItems(argSubjectID)
	}
	Quit:argCtrlItems="" return
	
	Set CtrlItems0="",CtrlItems1=""
	For i=1:1:$l(argCtrlItems,"/")
	{
		Set ItemID=$p(argCtrlItems,"/",i)
		Continue:ItemID=""
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		Set ItemActive=objItem.IsActive
		Continue:ItemActive'=1
		Set ItemAbsolute=objItem.IsAbsolute
		If ItemAbsolute=1 {
			Set CtrlItems1=CtrlItems1_ItemID_"/"
		}Else{
			Set CtrlItems0=CtrlItems0_ItemID_"/"
		}
	}
	
	//检查绝对条件，只要是有一个条件不符就退出
	Set flg=0
	For i=1:1:$l(CtrlItems1,"/")
	{
		Set ItemID=$p(CtrlItems1,"/",i)
		Continue:ItemID=""
		
		Set ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",1,ItemID)=""
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		Set Score=objItem.Score
		Set ItemDicDR=objItem.ItemDic
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicDR)
		Continue:'$IsObject(objItemDic)
		Set ItemDesc=objItemDic.IDDesc
		Set Expression=objItemDic.IDExpression
		Set Expression=##class(DHCMed.CCService.Sys.ExamExpress).changeExpression(Expression)
		Set ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",1,ItemID,"ItmScore")=Score
		Set ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",1,ItemID,"ItmExp")=Expression
		Set ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",1,ItemID,"ItmDesc")=ItemDesc
		//Modified By LiYang 2012-04-12 增加到其他系统的关联数据
		Set ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",1,ItemID,"Resume")=objItemDic.IDResume
		Set Count=Count+1
	}
	
	//检查一般条件，有几个条件符合，就显示几个结果
	For i=1:1:$l(CtrlItems0,"/")
	{
		Set ItemID=$p(CtrlItems0,"/",i)
		Continue:ItemID=""
		
		Set ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",0,ItemID)=""
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		Set Score=objItem.Score
		Set ItemDicDR=objItem.ItemDic
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicDR)
		Continue:'$IsObject(objItemDic)
		Set ItemDesc=objItemDic.IDDesc
		Set Expression=objItemDic.IDExpression
		Set Expression=##class(DHCMed.CCService.Sys.ExamExpress).changeExpression(Expression)
		Set ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",0,ItemID,"ItmScore")=Score
		Set ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",0,ItemID,"ItmExp")=Expression
		Set ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",0,ItemID,"ItmDesc")=ItemDesc
		//Modified By LiYang 2012-04-12 增加到其他系统的关联数据
		Set ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList",0,ItemID,"Resume")=objItemDic.IDResume	
		Set Count=Count+1
	}
	Set return=Count
	Quit return
}

}

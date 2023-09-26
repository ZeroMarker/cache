/// Creator: guozongtao
/// CreatDate: 
/// Description：新框架模板权限中 章 的处理类
Class EMRservice.DocRestLogic.CategoryActLogic Extends %RegisteredObject
{

/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：取出某个ChapterID下的第一个适用规则的DocID(打印模板 或 挂靠界面模板的目录)
/// Table:
/// Input: parPatInfo--病人信息列表（如 科室、性别等） ;parChapterID--Chapter的ID； parAction--操作类型，现在只有查看（这个没用）
/// Output:
/// Return:第一个符合规则的DocID(打印模板 或 挂靠界面模板的目录)
ClassMethod GetTempByCacAndAct(parPatInfo As %Library.List, parChapterID As %String, parAction As %String) As %String
{
	q:(($d(parChapterID)=0) || (parChapterID = "")) ""
	q:(($d(parAction)=0) || (parAction = "")) ""
	 
	 //依次取出parChapterID下的DocID,取得第一个具有权限的DocID后返回
	 s resultDocId = ""
	 s curChapterId = " "_parChapterID
	 s curseq = ""
	for
	{
		 s curseq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq",curChapterId,curseq))
		 q:(curseq = "")
		 s curDocId = 0
		 s curDocId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq", curChapterId,curseq, curDocId))
		 WHILE (curDocId '= "") 
		 {
			s curResult = ##Class(EMRservice.DocRestLogic.TempActLogic).CanTempAct(curDocId, parAction, parPatInfo)
			if (curResult = 1)
			{
				s resultDocId = $case(resultDocId,"":curDocId,:resultDocId_"^"_curDocId)
				
				//quit
			}
	  		s curDocId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq", curChapterId,curseq, curDocId))
		 }
	 }
	 q resultDocId
}

}

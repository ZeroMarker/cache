Class CHSSWeb.P8Active2 Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod ActiveAll() As %String
{
	;add by wangbo 2009-12-13
	;个人档案检索
	
	;老年人
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级')")
	;慢性病
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '高血压')")
	;检索地址
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%aa%')")
	;慢性病、老年人
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '高血压') and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级')")
	;老年人、地址
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级') and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%aa%')")
	;慢性病、地址
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%aa%') and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级')")
	;慢性病、老年人、家庭地址
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '高血压') and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级') and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%aa%')")
	
	;性别
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and SexDR = 1 ")
	;性别、老年人
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and SexDR = 1  and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级')")
	;性别、慢性病
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and SexDR = 1   and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '高血压')")
	;性别、检索地址
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and SexDR = 1   and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%aa%')")
	;性别、慢性病、老年人
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and SexDR = 1   and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '高血压') and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级')")
	;性别、老年人、家庭地址
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and SexDR = 1   and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级') and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%aa%')")
	;慢性病、家庭地址
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and SexDR = 1  and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%aa%') and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级')")
	;慢性病、老年人、家庭地址
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and SexDR = 1   and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '高血压') and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级') and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%aa%')")
	
	
	;检索其它地址
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where Address like '%aa%') ")
	;其它地址、老年人
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,""," and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级')  and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where Address like '%aa%') ")
	;其它地址、慢性病
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '高血压')  and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where Address like '%aa%') ")
	;其它地址、检索地址
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%aa%')  and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where Address like '%aa%') ")
	;其它地址、慢性病、老年人
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '高血压') and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级')  and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where Address like '%aa%') ")
	;其它地址、老年人、家庭地址
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级') and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%aa%')  and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where Address like '%aa%') ")
	;其它地址、慢性病、家庭地址
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%aa%') and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级')  and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where Address like '%aa%') ")
	;其它地址、慢性病、老年人、家庭地址
	w ##class(CHSSWeb.PHRSearchService).PersonSearchSql("100",0,1,"","  and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '高血压') and PersonRowId in (select PersonRowId from CHSS.ElerlyBaseInfo where ElerlyGrade = '一级') and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where VillageName like '%aa%')  and PersonRowId in (select PersonRowId from CHSS.PersonHealthRecordMain where Address like '%aa%') ")
	
	,!
	w ""
	,!
	w "P8Active2的激活已执行完毕,请执行P8Active3"
	,!

	q ""
}

Storage Default
{
<Data name="P8Active2DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.P8Active2D</DataLocation>
<DefaultData>P8Active2DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.P8Active2D</IdLocation>
<IndexLocation>^CHSSWeb.P8Active2I</IndexLocation>
<StreamLocation>^CHSSWeb.P8Active2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

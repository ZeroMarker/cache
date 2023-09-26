Import SQLUser

Class web.study.StudyTT Extends %RegisteredObject
{

// Function:SQL数据新增

// Creator:tianjialin

// Others:w ##class(web.study.StudyTT).InsertData()

ClassMethod InsertData() As %String
{
  &SQL(
  INSERT INTO SQLUser.DHC_CurseTJL(Crs_Code,Crs_Desc,Crs_Active)
  VALUES("01","男","Y") )
  //增不同包，可以在表名前加包，也可以Import SQLUser
  b ;
  q " "
}

}

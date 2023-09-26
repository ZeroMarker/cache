Class dhc.bonus.udata.uBonusPersonInfo Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：周马榜
/// CreatDate：2015-09-08
/// Description: 显示数据
/// Table：dhc_bonus_data.BonusPersonInfo
/// Input：
/// Return：SQL返回值
/// w ##class(dhc.bonus.udata.uBonusPersonInfo).ListRec("王娟","","","","",0,25)
ClassMethod ListRec(data, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
  n (data,searchField,searchValue,sortField,sortDir,start,limit)
  
  s SqlStr="SELECT * FROM dhc_bonus_data.BonusPersonInfo  "
          _" WHERE 1=1 "
         
  i data'="" s SqlStr=SqlStr_" AND (PersonName like '%"_data_"%' OR PersonCode like '%"_data_"%') "
 
  i sortField'="" d
  .i sortField = "SalaryAccount"   s sortField = "SalaryNumber"
  .e  i sortField = "Name"         s sortField = "PersonName"
  .e  i sortField = "WorkDate"     s sortField = "WorkDate"
  .e  i sortField = "DegreeCount"  s sortField = "Education"
  .e  s sortField = "Rowid"
  .s SqlStr = SqlStr_"ORDER BY "_sortField_" "_sortDir_" "
  ;s ^hahah = SqlStr
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(SqlStr)
  d result.Execute()

  s count=0
  s resultString=""
  s end=start+limit-1
  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^DeptClassify^personClassify^DeptName^SalaryAccount^Name^WorkDate^Position^Category^LunchCardId^newLunchId^CBCCardAccoun^CBCCardName^CMBCardAccount^CMBCardName^PositionDesc1^PositionDesc2^DegreeCount^TopTitle^SecondPosition"
  While(result.Next()){
		
    s rowid= result.Data("Rowid")
	s DeptClassify = result.Data("DeptType")
	i DeptClassify=1 s DeptClassify="管理"
	e  i DeptClassify=2 s DeptClassify="药剂"
	e  s DeptClassify="医疗"
	s personClassify = result.Data("PersonType")
	i personClassify=1 s personClassify="回聘"
	e  i personClassify=2 s personClassify="教编"
	e  i personClassify=3 s personClassify="外聘"
	e  i personClassify=4 s personClassify="下乡(教编)"
	e  i personClassify=5 s personClassify="下乡(外聘)"
	e  i personClassify=6 s personClassify="下乡(医编)"
	e  i personClassify=7 s personClassify="医编"
	e  i personClassify=8 s personClassify="引进"
	e  i personClassify=9 s personClassify="院聘专家"
	e  s personClassify="规培人员"
	s DeptName =""
	i result.Data("Dept")'="0"          s DeptName=result.Data("Dept")
    s SalaryAccount=  result.Data("SalaryNumber")
    s Name=  result.Data("PersonName")
	s WorkDate=  result.Data("WorkDate")
	i WorkDate'=""                      s WorkDate=$zd(WorkDate,3)
	s Position=""
	i result.Data("Post")'="0"          s Position=result.Data("Post") 
	s Category=""
	i result.Data("Category")'="0"      s Category=result.Data("Category")
	s LunchCardId=""
	i result.Data("FoodNumber")'="0"    s LunchCardId=result.Data("FoodNumber")
	s newLunchId=""
	i result.Data("NewFoodNumber")'="0" s newLunchId=result.Data("NewFoodNumber")
	s CBCCardAccoun=""
	i result.Data("CCBCard")'="0"       s CBCCardAccoun=result.Data("CCBCard") 
	s CBCCardName=""
	i result.Data("CCBName")'="0"       s CBCCardName=result.Data("CCBName")
	s CMBCardAccount=""
	i result.Data("CMBCard")'="0"       s CMBCardAccount=result.Data("CMBCard")
	s CMBCardName=""
	i result.Data("CMBName")'="0"       s CMBCardName=result.Data("CMBName")
	s PositionDesc1=""
	i result.Data("RemarkOne")'="0"     s PositionDesc1=result.Data("RemarkOne")
	s PositionDesc2= ""
	i result.Data("RemarkTwo")'= "0"    s PositionDesc2=result.Data("RemarkTwo")
	s DegreeCount=""
	i result.Data("Education")'="0"     s DegreeCount=result.Data("Education")
	s TopTitle=""
	i result.Data("SuperPost")'="0"     s TopTitle=result.Data("SuperPost")
	s SecondPosition=""
	i result.Data("Twopost")'="0"       s SecondPosition=result.Data("Twopost")

	 
	i (count>=start)&(count<=end) d
	.s tmp=rowid_"^"_DeptClassify_"^"_personClassify_"^"_DeptName_"^"_SalaryAccount_"^"_Name_"^"_WorkDate_"^"_Position_"^"_Category_"^"_LunchCardId_"^"_newLunchId_"^"_CBCCardAccoun_"^"_CBCCardName_"^"_CMBCardAccount_"^"_CMBCardName_"^"_PositionDesc1_"^"_PositionDesc2_"^"_DegreeCount_"^"_TopTitle_"^"_SecondPosition
	.d json.InsertRowData(tmp)
	s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：周马榜
/// CreatDate：2015-09-08
/// Description: 删除数据
/// Table：dhc_bonus_data.BonusPersonInfo
/// Input：要删除的数据ID
/// Return：SQL返回值
/// Others:w ##class(dhc_bonus_data.BonusPersonInfo).delete("1^2^3")
ClassMethod delete(data) As %String
{
  n (data)
  s rtn = 0
  f i=1:1 {   
	s rowid = ""
	s rowid = $p(data,"^",i)  
	q:rowid=""
	&SQL(DELETE from dhc_bonus_data.BonusPersonInfo WHERE Rowid=:rowid)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE'=0 s rtn =SQLCODE
  }
}

/// Creator：周马榜
/// CreatDate：2015-09-08
/// Description: 插入数据
/// Table：dhc_bonus_data.BonusPersonInfo
/// Input：要插入的数据
/// Return：SQL返回值
/// Others:w ##class(dhc.bonus.udata.uBonusPersonInfo).Insert("2^1^临床^01124323^李四^2015-09-09^医辅^医辅^123456^00123456^622288888232323344^李四^6226222222222222^李四^^^本科^^")
ClassMethod Insert(data) As %String
{
  n (data)
  s periodType = $p(data,"^",1) 
  s PersonType= $p(data,"^",2)
  s Dept = $p(data,"^",3)
  s SalaryNumber = $p(data,"^",4)
  s EmployName = $p(data,"^",5)
  s WorkDate = $p(data,"^",6)
  s Post = $p(data,"^",7)
  s Category = $p(data,"^",8)
  s FoodNumber = $p(data,"^",9)
  s NewFoodNumber = $p(data,"^",10)
  s CCBCard = $p(data,"^",11)
  s CCBName = $p(data,"^",12)
  s CMBCard = $p(data,"^",13)
  s CMBName = $p(data,"^",14)
  s RemarkOne = $p(data,"^",15)
  s RemarkTwo = $p(data,"^",16)
  s Education = $p(data,"^",17)
  s SuperPost = $p(data,"^",18)
  s Twopost = $p(data,"^",19)
  s p="P"
  s PersonCode=p_SalaryNumber
  
  i Dept  =""        s Dept=0
  i SalaryNumber=""  s SalaryNumbert=0
  i Post=""          s Post=0
  i Category=""      s Category=0
  i FoodNumber=""    s FoodNumber=0
  i NewFoodNumber="" s NewFoodNumber=0
  i CCBCard=""       s CCBCard=0
  i CCBName=""       s CCBName=0
  i CMBCard=""       s CMBCard=0
  i CMBName=""       s CMBName=0
  i RemarkOne=""     s RemarkOne=0
  i RemarkTwo=""     s RemarkTwo=0
  i Education=""     s Education=0
  i SuperPost=""     s SuperPost=0
  i Twopost=""       s Twopost  =0
  s WorkDate=$zdh(WorkDate,3)
  &SQL(INSERT INTO dhc_bonus_data.BonusPersonInfo(DeptType,PersonCode,PersonType,Dept,SalaryNumber,PersonName,WorkDate,Post,Category,FoodNumber,NewFoodNumber,CCBCard,CCBName,CMBCard,CMBName,RemarkOne,RemarkTwo,Education,SuperPost,Twopost) 
  VALUES(:periodType,:PersonCode,:PersonType,:Dept,:SalaryNumber,:EmployName,:WorkDate,:Post,:Category,:FoodNumber,:NewFoodNumber,:CCBCard,:CCBName,:CMBCard,:CMBName,:RemarkOne,:RemarkTwo,:Education,:SuperPost,:Twopost))
  
  q SQLCODE
}

/// Creator：周马榜
/// CreatDate：2015-06-19
/// Description: 修改数据
/// Table：dhc_bonus_data.BonusPersonInfo
/// Input：要修改的数据
/// Return：SQL返回值
/// Others:w ##class(dhc_bonus_data.BonusPersonInfo).Update("2^1^临床^01124323^李四^2015-09-09^医辅^医辅^123456^00123456^622288888232323344^李四^6226222222222222^李四^^^本科^^^7310") 
ClassMethod Update(data) As %String
{
  n (data)
  s periodType = $p(data,"^",1) 
  s PersonType= $p(data,"^",2)
  s Dept = $p(data,"^",3)
  s SalaryNumber = $p(data,"^",4)
  s EmployName = $p(data,"^",5)
  s WorkDate = $p(data,"^",6)
  s Post = $p(data,"^",7)
  s Category = $p(data,"^",8)
  s FoodNumber = $p(data,"^",9)
  s NewFoodNumber = $p(data,"^",10)
  s CCBCard = $p(data,"^",11)
  s CCBName = $p(data,"^",12)
  s CMBCard = $p(data,"^",13)
  s CMBName = $p(data,"^",14)
  s RemarkOne = $p(data,"^",15)
  s RemarkTwo = $p(data,"^",16)
  s Education = $p(data,"^",17)
  s SuperPost = $p(data,"^",18)
  s Twopost = $p(data,"^",19)
  s RowId=$p(data,"^",20)
  s PersonCode="P"_SalaryNumber
  
  i Dept=""          s Dept=0
  i SalaryNumber=""  s SalaryNumbert=0
  i Post=""          s Post=0
  i Category=""      s Category=0
  i FoodNumber=""    s FoodNumber=0
  i NewFoodNumber="" s NewFoodNumber=0
  i CCBCard=""       s CCBCard=0
  i CCBName=""       s CCBName=0
  i CMBCard=""       s CMBCard=0
  i CMBName=""       s CMBName=0
  i RemarkOne=""     s RemarkOne=0
  i RemarkTwo=""     s RemarkTwo=0
  i Education=""     s Education=0
  i SuperPost=""     s SuperPost=0
  i Twopost=""       s Twopost=0
  s WorkDate=$zdh(WorkDate,3)
  &SQL(UPDATE dhc_bonus_data.BonusPersonInfo SET DeptType=:periodType,PersonCode=:PersonCode,PersonType=:PersonType,Dept=:Dept,SalaryNumber=:SalaryNumber,PersonName=:EmployName,WorkDate=:WorkDate,Post=:Post,Category=:Category,FoodNumber=:FoodNumber,NewFoodNumber=:NewFoodNumber,CCBCard=:CCBCard,CCBName=:CCBName,CMBCard=:CMBCard,CMBName=:CMBName,RemarkOne=:RemarkOne,RemarkTwo=:RemarkTwo,Education=:Education,SuperPost=:SuperPost,Twopost=:Twopost WHERE Rowid=:RowId)
  i SQLCODE=100 s SQLCODE=0
  q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus641.uBonusPerson67FS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

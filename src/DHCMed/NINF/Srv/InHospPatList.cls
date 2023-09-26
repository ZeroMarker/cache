/// 名称: DHCMed.NINF.Srv.InHospPatList
/// 描述: 医政管理 记录每天在院患者信息
/// 编写者：LiuYH
/// 编写日期: 2012-12-13
Class DHCMed.NINF.Srv.InHospPatList Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1) [ Required ];

/// 科室
Property CtlocID As %String(TRUNCATE = 1);

//[ Required ];

/// 病区
Property WardID As %String(TRUNCATE = 1);

/// 病房
Property RoomID As %String(TRUNCATE = 1);

/// 床
Property BedID As %String(TRUNCATE = 1);

/// 主管医生
Property DoctorID As %String(TRUNCATE = 1);

/// 在院日期
Property InHospDate As %String(TRUNCATE = 1) [ Required ];

/// 在院日期、就诊索引
Index DateEpisodeID On (InHospDate, EpisodeID) [ Unique ];

/// 在院日期、科室、就诊索引
Index DateLocEpisodeID On (InHospDate, CtlocID, EpisodeID);

// [ Unique ];

/// Creator：     LiuYH
/// CreatDate：   2012-12-13
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.NINF.Srv.InHospPatList
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: EpisodeID 3: CtlocID 4: WardID 5: RoomID 6：BedID 7：DoctorID 9：InHospDate
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..EpisodeID_separete
	set return=return_..CtlocID_separete
	set return=return_..WardID_separete
	set return=return_..RoomID_separete
	
	set return=return_..BedID_separete
	set return=return_..DoctorID_separete
	set return=return_..InHospDate
	
	quit return
}

/// Creator：     LiuYH
/// CreatDate：   2012-12-13
/// Description:  根据ID取患者在院信息
/// Table：       DHCMed.NINF.Srv.InHospPatList
/// Input：       ID:    DHCMed.NINF.Srv.InHospPatList.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Srv.InHospPatList).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.Srv.InHospPatList
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Srv.InHospPatList).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Srv.InHospPatList).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     LiuYH
/// CreatDate：   2012-12-13
/// Description:  根据ID取患者在院信息
/// Table：       DHCMed.NINF.Srv.InHospPatList
/// Input：       ID:    DHCMed.NINF.Srv.InHospPatList.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.NINF.Srv.InHospPatList).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     LiuYH
/// CreatDate：   2012-12-13
/// Description:  更新患者在院信息
/// Table：       DHCMed.NINF.Srv.InHospPatList
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.NINF.Srv.InHospPatList).%New()
		} 
	else {
		set obj=##class(DHCMed.NINF.Srv.InHospPatList).%OpenId(ID)
		}
	set obj.EpisodeID=$p(InStr,separete,2)
	set obj.CtlocID=$p(InStr,separete,3)
	set obj.WardID=+$p(InStr,separete,4)
	set obj.RoomID=$p(InStr,separete,5)
	set obj.BedID=$p(InStr,separete,6)
	set obj.DoctorID=$p(InStr,separete,7)
	set obj.InHospDate=+$p(InStr,separete,8)
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     LiuYH
/// CreatDate：   2012-12-13
/// Description:  删除患者在院信息
/// Table：       DHCMed.NINF.Srv.InHospPatList
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.NINF.Srv.InHospPatList).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     LiuYH
/// CreatDate：   2012-12-13
/// Description:  更新患者当前在院信息
/// 			  该方法用在感染自动任务中，凌晨执行
/// Table：       DHCMed.NINF.Srv.InHospPatList
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<=0的代码
/// w ##class(DHCMed.NINF.Srv.InHospPatList).UpdateByPaadm(1)
ClassMethod UpdateByPaadm(Paadm As %String, CurrDate As %String) As %String
{
	new (Paadm,CurrDate)
	set ret=0
	quit:(Paadm="")||(CurrDate="") ret
	
	//当天数据已处理，不在重复处理
	quit:$d(^DHCMed.NINFSi("InHospPat",0,"DateEpisodeID"," "_CurrDate," "_Paadm)) 1
	
	quit:'$d(^PAADM(Paadm)) ret
	
	set (DepartmentID,WardID,RoomID,BedID,DoctorID)=""
	
	/* update by zf 2013-04-15 此任务，科室病区暂时不处理
	set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
	quit:'$IsObject(AdmObj) ret
	do AdmObj.%Close()
	set DepartmentID=AdmObj.DepartmentID
	set WardID=AdmObj.WardID
	set RoomID=AdmObj.RoomID
	set BedID=AdmObj.BedID
	set DoctorID=AdmObj.DoctorID
	*/
	
	set obj=##class(DHCMed.NINF.Srv.InHospPatList).%New()
	set obj.EpisodeID=Paadm
	set obj.InHospDate=CurrDate
	set obj.CtlocID=DepartmentID
	set obj.WardID=WardID
	set obj.RoomID=RoomID
	set obj.BedID=BedID
	set obj.DoctorID=DoctorID
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {       //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	} else {
		set id=obj.%Id()
	}
	do obj.%Close()
	
	quit id
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>CtlocID</Value>
</Value>
<Value name="4">
<Value>WardID</Value>
</Value>
<Value name="5">
<Value>RoomID</Value>
</Value>
<Value name="6">
<Value>BedID</Value>
</Value>
<Value name="7">
<Value>DoctorID</Value>
</Value>
<Value name="8">
<Value>InHospDate</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFS("InHospPat")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFS("InHospPat")</IdLocation>
<IndexLocation>^DHCMed.NINFSi("InHospPat",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Srv.InHospPatListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

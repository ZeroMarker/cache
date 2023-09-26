/// 名称: web.DHCCPW.MRC.PathWayEp
/// 描述：对临床路径阶段的各种操作分别有添加，删除，修改，查询等操作
/// 编写者：李宇峰
/// 编写日期：2010-04-30
Class web.DHCCPW.MRC.PathWayEp Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-11-07
/// Description:  根据ID取临床路径阶段
/// Table：       User.DHCMRCClinPathWaysEp
/// Input：       ID:    User.DHCMRCClinPathWaysEp.Id
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.PathWayEp).GetObjById("1||1")
ClassMethod GetObjById(argId As %String) As User.DHCMRCClinPathWaysEp
{
	New (argId)
	Set return=##Class(User.DHCMRCClinPathWaysEp).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-04-30
/// Description:此Query是用来得到指定临床路径下的所有阶段的全部记录
/// Table:User.DHCMRCClinPathWaysEp
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWayEp","GetPathWayEp",1)
Query GetPathWayEp(argCPWID) As %Query(ROWSPEC = "Rowid:%String,desc:%String,episode:%String,notes:%String")
{
}

ClassMethod GetPathWayEpExecute(ByRef qHandle As %Binary, argCPWID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set EpID=0
	For {
		Set EpID=$o(^DHCMRC("CPW",argCPWID,"EP",EpID))
		Quit:EpID=""
		Set EpRowID=argCPWID_"||"_EpID
		Set objEp=..GetObjById(EpRowID)
		If $IsObject(objEp){
			Set Desc=objEp.EPDesc
			Set Episode=objEp.EPEpisode   // 阶段序号
			Set Notes=objEp.EPNotes       // 阶段备注
			Set Data=$lb(EpRowID,Desc,Episode,Notes)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod GetPathWayEpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPathWayEpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPathWayEpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPathWayEpExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:李宇峰
/// CreatDate:2010-04-30
/// Description:GetNewEpisode用来得到指定的临床路径下面的阶段最新的序号。
/// Table:User.DHCMRCClinPathWaysEp
/// w ##class(web.DHCCPW.MRC.PathWayEp).GetNewEpisode(1)
ClassMethod GetNewEpisode(argCPWID As %String)
{
	New (argCPWID)
	Set return=0
	Quit:argCPWID="" return
	
	Set EpID=0
	For {
		Set EpID=$o(^DHCMRC("CPW",argCPWID,"EP",EpID))
		Quit:EpID=""
		Set EpRowID=argCPWID_"||"_EpID
		Set objEp=..GetObjById(EpRowID)
		If $IsObject(objEp){
			Set Desc=objEp.EPDesc
			Set Episode=+objEp.EPEpisode   // 阶段序号
			Set Notes=objEp.EPNotes       // 阶段备注
			Set:Episode>return return=Episode
		}
	}
	
	Set return=return+1
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-04-30
/// Description:AddPathWayEp插入一条新的记录。
/// Table:User.DHCMRCClinPathWaysEp
ClassMethod AddPathWayEp(CPWID As %String, Desc As %String, Episode As %String, Notes As %String)
{
	New (CPWID,Desc,Episode,Notes)
	Set return=-1
	Quit:(CPWID="")||(Desc="")||(Episode="") return
	
	Set InputStr=CPWID_"^"_""_"^"_Desc_"^"_Episode_"^"_Notes
	Set return=..Update(InputStr)
	Quit return
}

ClassMethod UpdatePathWayEp(Rowid As %String, Desc As %String, Episode As %String, Notes As %String)
{
	New (Rowid,Desc,Episode,Notes)
	Set return=-1
	Quit:(Rowid="")||(Desc="")||(Episode="") return
	
	Set CPWID=$p(Rowid,"||",1)
	Set EpID=$p(Rowid,"||",2)
	Set InputStr=CPWID_"^"_EpID_"^"_Desc_"^"_Episode_"^"_Notes
	Set return=..Update(InputStr)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-11-01
/// Description:  保存临床路径阶段
/// Table：       User.DHCMRCClinPathWaysEp
/// Input：       argInPut: 临床路径阶段数据
/// Return：      return<0: 保存失败
/// w ##Class(web.DHCCPW.MRC.PathWayEp).Update(argInput)
ClassMethod Update(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set ParRef=$p(argInput,"^",1)
	Quit:ParRef="" return
	Set ChildSub=$p(argInput,"^",2)
	If ChildSub="" {
		Set obj=##class(User.DHCMRCClinPathWaysEp).%New()
	} Else {
		Set ID=ParRef_"||"_ChildSub
		Set obj=##class(User.DHCMRCClinPathWaysEp).%OpenId(ID)
		Quit:obj="" return
	}
	
	Set objParRef=##Class(User.DHCMRCClinPathWays).%OpenId(ParRef)
	If objParRef'="" Do objParRef.%Close()
	Set Desc=$p(argInput,"^",3)
	Set Episode=+$p(argInput,"^",4)
	Set Notes=$p(argInput,"^",5)
	Quit:(Desc="")||(Episode<1)||(objParRef="") return
	
	Set obj.EPParRef=objParRef
	Set obj.EPDesc=Desc        //阶段描述
	Set obj.EPEpisode=Episode  //阶段序号
	Set obj.EPNotes=Notes      //阶段备注
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// w ##class(web.DHCCPW.MRC.PathWayEp).DeletePathWayEp("1||1")
ClassMethod DeletePathWayEp(argId As %String)
{
	new (argId)
	set return=0
	set sc = ##class(User.DHCMRCClinPathWaysEp).%DeleteId(argId)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}
	quit return
}

/// w ##class(web.DHCCPW.MRC.PathWayEp).FindPathWayEp(1)
ClassMethod FindPathWayEp(argCPWID As %String)
{
	New (argCPWID)
	Set return=""
	Quit:argCPWID="" return
	
	Set EpID=0
	For {
		Set EpID=$o(^DHCMRC("CPW",argCPWID,"EP",EpID))
		Quit:EpID=""
		Set EpRowID=argCPWID_"||"_EpID
		Set objEp=..GetObjById(EpRowID)
		If $IsObject(objEp){
			Set Desc=objEp.EPDesc
			Set Episode=+objEp.EPEpisode   // 阶段序号
			Set Notes=objEp.EPNotes        // 阶段备注
			Set Desc=$tr(Desc,"^","")
			Set Desc=$tr(Desc,$c(0),"")
			Set Desc=$tr(Desc,$c(10),"")
			Set Desc=$tr(Desc,$c(13),"")
			Set return=return_","_EpRowID_"^"_Desc_"--"_Episode
		}
	}
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// w ##Class(web.DHCCPW.MRC.PathWayEp).CheckSameEpisode(2,2,"")
ClassMethod CheckSameEpisode(argEpisode As %String, argCPWID As %String, argEpRowID As %String)
{
	New (argEpisode,argCPWID,argEpRowID)
	Set return=0
	Quit:(argCPWID="")||(argEpisode="") return
	
	Set EpID=0
	For {
		Set EpID=$o(^DHCMRC("CPW",argCPWID,"EP",EpID))
		Quit:(EpID="")||(return=1)
		Set EpRowID=argCPWID_"||"_EpID
		Continue:(argEpRowID'="")&&(argEpRowID=EpRowID)
		Set objEp=..GetObjById(EpRowID)
		If $IsObject(objEp){
			Set Desc=objEp.EPDesc
			Set Episode=+objEp.EPEpisode   // 阶段序号
			Set Notes=objEp.EPNotes        // 阶段备注
			Continue:Episode'=argEpisode
			Set return=1
		}
	}
	
	Quit return
}

}

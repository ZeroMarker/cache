/// 报告时间分段
/// 程序均取自相应报表
Class dhc.bonus.uinter.uSectionReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: LXW
/// CreatDate: 2015-09-17
/// Description: 获取分段时间报告数量
/// Table: 
/// Input: 开始时间，结束时间
/// 表表DHCz-jgb4报告时间段分布.raq  类：web.DHCzJGBQuery 方法：bgsjfdExecute
/// Others:w ##class(dhc.bonus.uinter.uSectionReport).bgsjfdExecute("2015-08-1","2015-08-10",6)
ClassMethod bgsjfdExecute(StartDate As %String, EndDate As %String, MethodDr As %String) As %String
{
	// D ##class(%ResultSet).RunQuery("web.DHCzJGBQuery","bgsjfd","2015-8-1","2015-8-31")
   n (StartDate,EndDate,MethodDr)  
  s Year=$p(StartDate,"-",1)
  s Month=$p(StartDate,"-",2)
  s sMonth="M"_ Month
  //删除已采集的同类数据
  &sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:Year and BonusPeriod=:sMonth and InterLocMethodID=:MethodDr )
  
  
  Quit:StartDate="" 0 
  Quit:EndDate="" 0  
  s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)

  k ^Temp("bgsjfd",$j)
  s CurrentSpace=$znspace
  ;Set repListStream = ##class(%GlobalCharacterStream).%New()
 	
 ;zn "PACS"
  f mydate=StartDate:1:EndDate 
 {
 d ##class(web.DHCzJGBQuery).GetPacsStream(mydate)
 }
 ;zn CurrentSpace
 ;zw ^Temp("bgsjfd",$j,"staccnum")
 

 s Indate="" f  s Indate=$O(^Temp("bgsjfd",$j,"staccnum",Indate)) q:Indate=""  d
 .s staccnum="" f  s staccnum=$O(^Temp("bgsjfd",$j,"staccnum",Indate,staccnum)) q:staccnum=""  d
 ..s (infoStr,ks,sqsj,bgsj,sjc,sjclx,pno2,brlx)=""
 ..s (sqsjDate,sqsjTime,bgsjDate,bgsjTime,cDate,cTime)=""
 ..s infoStr=^Temp("bgsjfd",$j,"staccnum",Indate,staccnum)
 ..s ks=$P(infoStr,"^",9),sqsj=$P(infoStr,"^",21),bgsj=$P(infoStr,"^",17),brlx=$P(infoStr,"^",24),zxks=$P(infoStr,"^",6)
 ..;i ks="" w !,staccnum
 ..i (brlx="HMP")&(ks="") s ks="体检科"
 ..q:ks=""
 ..;i $F(ks,"-")>0 s ks=$P(ks,"-",2)
 ..;i $F(zxks,"-")>0 s zxks=$P(zxks,"-",2)
 ..s sqsjDate=$P(sqsj," ",1),sqsjTime=$P(sqsj," ",2)
 ..s bgsjDate=$P(bgsj," ",1),bgsjTime=$P(bgsj," ",3)
 ..i $F(sqsjDate,"-")>0 s sqsjDate=$zdh(sqsjDate,3)
 ..i $F(sqsjTime,":")>0 s sqsjTime=$zth(sqsjTime)
 ..i $F(bgsjDate,"-")>0 s bgsjDate=$zdh(bgsjDate,3)
 ..i $F(bgsjTime,":")>0 s bgsjTime=$zth(bgsjTime)
 ..s cDate=bgsjDate-sqsjDate,cTime=bgsjTime-sqsjTime
 ..s sjc=(cDate*24)+(cTime/3600)   //换算为小时
 ..i sjc<=24 s sjclx="24内"
 ..i (sjc>24)&(sjc<=48) s sjclx="24至48"
 ..i sjc>48 s sjclx="48以上"
 ..i '$D(^Temp("bgsjfd",$j,"All",zxks,sjclx)) s ^Temp("bgsjfd",$j,"All",zxks,sjclx)=1
 ..e  s ^Temp("bgsjfd",$j,"All",zxks,sjclx)=^Temp("bgsjfd",$j,"All",zxks,sjclx)+1
  
  ;zw ^Temp("bgsjfd")
  
  s zxks="" f  s zxks=$O(^Temp("bgsjfd",$j,"All",zxks)) q:zxks=""  d
  .s sjclx="" f  s sjclx=$O(^Temp("bgsjfd",$j,"All",zxks,sjclx)) q:sjclx=""  d
  ..s sl=""
  ..s sl=^Temp("bgsjfd",$j,"All",zxks,sjclx)
  ..d outputbrrcz     
    
  k ^Temp("bgsjfd",$j)
	Quit 0
	
outputbrrcz
    s DeptID=..GetDeptID(zxks)
    s ItemCode=""
    i sjclx="24内" s ItemCode="04017"
    i sjclx="24至48" s ItemCode="04018"
    i sjclx="48以上" s ItemCode="04019"
    ;w DeptID,zxks,sjclx,sl,!
    q:DeptID=0
    &sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
      values(:ItemCode,:sjclx,:DeptID,:zxks,:Year,:sMonth,:sl,getdate(), 0,0,:MethodDr))
    quit
}

/// Creator: LXW
/// CreatDate: 2015-09-17
/// Description: 根据科室名称获取科室ID
/// Table: CT_Loc
/// Input: 科室名称
/// Output: 
/// Return: 科室ID
/// others: w ##class(dhc.bonus.uinter.uSectionReport).GetDeptID("FSKWCS-放射科胃肠室")
ClassMethod GetDeptID(DeptName) As %Integer
{
	n (DeptName)
	q:DeptName="" 0
	s sqlStr="SELECT CTLOC_RowID FROM CT_Loc WHERE CTLOC_Desc='"_DeptName_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s DeptID=0	 
	While(result.Next()){
		s DeptID=result.Data("CTLOC_RowID")
		}
	
	q DeptID
}

/// Creator: LXW
/// CreatDate: 2015-09-17
/// Description: 获取分段时间报告数量(这部分全算24小时以内的，有部分科室24小时在bgsjfdExecute中已取，这里不再取。)
/// Table: 
/// Input: 开始时间，结束时间
/// 表表：DHCz-医技科室访问人次.raq  类：web.DHCcwStatisties 方法：yjksgzlExecute
/// Others:w ##class(dhc.bonus.uinter.uSectionReport).bgsjfdExecute("2015-08-1","2015-08-10",6)
/// others: w ##class(dhc.bonus.uinter.uSectionReport).yjksgzlExecute("2014-01-01","2014-01-15",7)
ClassMethod yjksgzlExecute(StartDate As %String, EndDate As %String, MethodDr As %String) As %String
{
    n (StartDate,EndDate,MethodDr)  
  s Year=$p(StartDate,"-",1)
  s Month=$p(StartDate,"-",2)
  s sMonth="M"_ Month
  Quit:StartDate="" 0 
  Quit:EndDate="" 0 
  //删除已采集的同类数据
  ;&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:Year and BonusPeriod=:sMonth and InterLocMethodID=:MethodDr )
  k ^Temp("yjksgzl",$J) 

  s StartDate=$zdh(StartDate,3), EndDate=$zdh(EndDate,3)
  s mydate="" ,LocGrop="5,6,10"  //科室分组  10医技科室,5检查科室,6	检验
  s DeptList=$lb(144,145,173,174,175,176,177,178,179,183,187,100)
  f mydate=StartDate:1:EndDate d
  .s wlId="" f  s wlId=$O(^DHCWorkLoad(0,"FlagDate",mydate,wlId)) q:wlId=""  d
  ..s (wlstr,RecDeptId,RecDeptName,AdmId)=""
  ..s wlstr=^DHCWorkLoad(wlId)
  ..s RecDeptId=$P(wlstr,"^"),AdmId=$P(wlstr,"^",12)
  ..q:RecDeptId=""
  ..;q:$P(^CTLOC(RecDeptId),"^",19)'=5     
  ..q:$F(LocGrop,$P(^CTLOC(RecDeptId),"^",19))<=0
  ..s RecDeptName= $P($P(^CTLOC(RecDeptId),"^",2),"-",2)_"^"_RecDeptId
  ..i '$D(^Temp("yjksgzl",$J,"0",RecDeptName))  s ^Temp("yjksgzl",$J,"0",RecDeptName)=0 
  ..i '$D(^Temp("yjksgzl",$J,RecDeptName,AdmId)) d
  ...s ^Temp("yjksgzl",$J,RecDeptName,AdmId)=1
  ...s ^Temp("yjksgzl",$J,"0",RecDeptName)=(+^Temp("yjksgzl",$J,"0",RecDeptName))+1
  
  s RecDeptName="" f  s RecDeptName=$O(^Temp("yjksgzl",$J,"0",RecDeptName)) q:RecDeptName=""  d
  .s rc=""
  .s rc=+^Temp("yjksgzl",$J,"0",RecDeptName)
  .d OutPutrow2
  
  k ^Temp("yjksgzl",$J) 
  s Vau=##class(dhc.bonus.uinter.uGetYWSRgdj).GetYWQuantity(StartDate,EndDate,"767||1")
  s sum=rc+Vau
  Quit 0
  
OutPutrow2
 ;w RecDeptName_"^"_rc,!
 s DeptName=$p(RecDeptName,"^",1)
 s DeptID=$p(RecDeptName,"^",2)
 //部分科室的24小时内已在"bgsjfdExecute"中取出，这里就不再取
 q:$ListFind(DeptList,DeptID)>0
 s ItemName="24小时内",ItemCode="04017"
 &sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
      values(:ItemCode,:ItemName,:DeptID,:DeptName,:Year,:sMonth,:rc,getdate(), 0,0,:MethodDr))
 
 quit
 
 /*
 CT室   174 
产科超声室  187
超声心动图室  179
超声医学科    144
放射科介入室  175
放射科普通摄片室  145 
放射科胃肠室  177
核磁共振室    176
核医学科影像室  183
经颅多谱勒室   173
胃镜室         178
 */
}

Storage Default
{
<StreamLocation>^dhc.bonus.u1BEE.uSectionReportS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

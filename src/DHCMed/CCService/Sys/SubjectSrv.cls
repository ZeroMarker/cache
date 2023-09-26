/// 名称: DHCMed.CCService.Sys.SubjectSrv
/// 描述: DHCMed.CC.Subject 监控主题常用方法
/// 编写者：liuyh
/// 编写日期: 2010-09-26
Class DHCMed.CCService.Sys.SubjectSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-09-26
/// Description:  查询监控主题信息
/// Table：       DHCMed.CC.Subject
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.SubjectSrv","QrySubject","")
Query QrySubject(argTitle As %String, argIsActive As %String = "") As %Query(ROWSPEC = "rowid:%String,Title:%String,Code:%String,Desc:%String,IsActive:%String,IsActiveDesc:%String,Categroy:%String,Expression:%String,ResumeText:%String,IsAutoRun:%String,IsAutoRunDesc:%String,IsTimeLine:%String,IsTimeLineDesc:%String")
{
}

ClassMethod QrySubjectExecute(ByRef qHandle As %Binary, argTitle As %String, argIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set SubjectID=0
	For {
		Set SubjectID=$o(^DHCMed.CC("Subject",SubjectID))
		Quit:SubjectID=""
		Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
		If $IsObject(objSubject){
			Set Title=objSubject.Title
			Continue:(argTitle'="")&&(argTitle'=Title)
			Continue:(argIsActive'="")&&(argIsActive'=objSubject.IsActive) 
			Set Code=objSubject.Code
			Set Description=objSubject.Description
			Set IsActive=objSubject.IsActive
			Set SubActive=$s(IsActive=0:"否",1:"是")
			Set Categroy=objSubject.Categroy
			Set Expression=objSubject.Expression
			Set ResumeText=objSubject.ResumeText
			Set IsAutoRun=objSubject.IsAutoRun
			Set IsAutoRun=+IsAutoRun
			Set IsAutoRunDesc=$s(IsAutoRun=1:"是",1:"否")
			Set IsTimeLine=objSubject.IsTimeLine
			Set IsTimeLine=+IsTimeLine
			Set IsTimeLineDesc=$s(IsTimeLine=1:"是",1:"否")
			Set Data=$lb(SubjectID,Title,Code,Description,IsActive,SubActive,Categroy,Expression,ResumeText,IsAutoRun,IsAutoRunDesc,IsTimeLine,IsTimeLineDesc)
			Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QrySubjectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubjectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySubjectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubjectExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询颜色
Query QueryColor() As %Query(ROWSPEC = "ColorNumber:%String:颜色值,ColorName:%String:颜色名称")
{
}

ClassMethod QueryColorExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set strColors="AliceBlue#F0F8FF^AntiqueWhite#FAEBD7^Aqua#00FFFF^Aquamarine#7FFFD4^Azure#F0FFFF^Beige#F5F5DC^Bisque#FFE4C4^Black#000000^BlanchedAlmond#FFEBCD^Blue#0000FF^BlueViolet#8A2BE2^Brown#A52A2A^BurlyWood#DEB887^CadetBlue#5F9EA0^Chartreuse#7FFF00^Chocolate#D2691E^Coral#FF7F50^CornflowerBlue#6495ED^Cornsilk#FFF8DC^Crimson#DC143C^Cyan#00FFFF^DarkBlue#00008B^DarkCyan#008B8B^DarkGoldenrod#B8860B^DarkGray#A9A9A9^DarkGreen#006400^DarkKhaki#BDB76B^DarkMagenta#8B008B^DarkOliveGreen#556B2F^DarkOrange#FF8C00^DarkOrchid#9932CC^DarkRed#8B0000^DarkSalmon#E9967A^DarkSeaGreen#8FBC8F^DarkSlateBlue#483D8B^DarkSlateGray#2F4F4F^DarkTurquoise#00CED1^DarkViolet#9400D3^DeepPink#FF1493^DeepSkyBlue#00BFFF^DimGray#696969^DodgerBlue#1E90FF^FireBrick#B22222^FloralWhite#FFFAF0^ForestGreen#228B22^Fuchsia#FF00FF^Gainsboro#DCDCDC^GhostWhite#F8F8FF^Gold#FFD700^Goldenrod#DAA520^Gray#808080^Green#008000^GreenYellow#ADFF2F^Honeydew#F0FFF0^HotPink#FF69B4^IndianRed#CD5C5C^Indigo#4B0082^Ivory#FFFFF0^Khaki#F0E68C^Lavender#E6E6FA^LavenderBlush#FFF0F5^LawnGreen#7CFC00^LemonChiffon#FFFACD^LightBlue#ADD8E6^LightCoral#F08080^LightCyan#E0FFFF^LightGoldenrodYellow#FAFAD2^LightGreen#90EE90^LightGrey#D3D3D3^LightPink#FFB6C1^LightSalmon#FFA07A^LightSeaGreen#20B2AA^LightSkyBlue#87CEFA^LightSlateGray#778899^LightSteelBlue#B0C4DE^LightYellow#FFFFE0^Lime#00FF00^LimeGreen#32CD32^Linen#FAF0E6^Magenta#FF00FF^Maroon#800000^MediumAquamarine#66CDAA^MediumBlue#0000CD^MediumOrchid#BA55D3^MediumPurple#9370DB^MediumSeaGreen#3CB371^MediumSlateBlue#7B68EE^MediumSpringGreen#00FA9A^MediumTurquoise#48D1CC^MediumVioletRed#C71585^MidnightBlue#191970^MintCream#F5FFFA^MistyRose#FFE4E1^Moccasin#FFE4B5^NavajoWhite#FFDEAD^Navy#000080^OldLace#FDF5E6^Olive#808000^OliveDrab#6B8E23^Orange#FFA500^OrangeRed#FF4500^Orchid#DA70D6^PaleGoldenrod#EEE8AA^PaleGreen#98FB98^PaleTurquoise#AFEEEE^PaleVioletRed#DB7093^PapayaWhip#FFEFD5^PeachPuff#FFDAB9^Peru#CD853F^Pink#FFC0CB^Plum#DDA0DD^PowderBlue#B0E0E6^Purple#800080^Red#FF0000^RosyBrown#BC8F8F^RoyalBlue#4169E1^SaddleBrown#8B4513^Salmon#FA8072^SandyBrown#F4A460^SeaGreen#2E8B57^Seashell#FFF5EE^Sienna#A0522D^Silver#C0C0C0^SkyBlue#87CEEB^SlateBlue#6A5ACD^SlateGray#708090^Snow#FFFAFA^SpringGreen#00FF7F^SteelBlue#4682B4^Tan#D2B48C^Teal#008080^Thistle#D8BFD8^Tomato#FF6347^Turquoise#40E0D0^Violet#EE82EE^Wheat#F5DEB3^White#FFFFFF^WhiteSmoke#F5F5F5^Yellow#FFFF00^YellowGreen#9ACD32^"
	For cnt=1:1:$l(strColors,"^")
	{
		Set tmpColor=$p(strColors,"^",cnt)
		Set Data=""
		Set $li(Data,1)="#"_$p(tmpColor,"#",2)
		Set $li(Data,2)="<div style='background-color:"_$p(tmp,"#",2)_"'>"_$p(tmpColor,"#",1)_"</div>"
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryColorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryColorExecute ]
{
	Set repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryColorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryColorExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2010-11-04
/// Description:  通过主题ID查询主题颜色信息
/// Table：       DHCMed.CC.SubjectColor
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.SubjectSrv","QrySubColorByID","1")
Query QrySubColorByID(argSubjectID As %String) As %Query(ROWSPEC = "rowid:%String,ColorRGB:%String,SubjectDr:%String,Score:%String")
{
}

ClassMethod QrySubColorByIDExecute(ByRef qHandle As %Binary, argSubjectID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:argSubjectID="" $$$OK
	Set ColorID=0
	For {
		Set ColorID=$o(^DHCMed.CCi("SColor",0,"SubjectIndex",argSubjectID,ColorID))
		Quit:ColorID=""
		Set objColor=##class(DHCMed.CC.SubjectColor).GetObjById(ColorID)
		If $IsObject(objColor){
			Set ColorRGB=objColor.ColorRGB
			Set SubjectDr=objColor.SubjectDr
			Set Score=objColor.Score
			Set Data=$lb(ColorID,ColorRGB,SubjectDr,Score)
			Set ^CacheTemp(repid,ind)=data
    		Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QrySubColorByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubColorByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySubColorByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubColorByIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取监控主题对应就诊类型
/// w ##Class(DHCMed.CCService.Sys.SubjectSrv).GetSubjectAdmType("INTCCS")
ClassMethod GetSubjectAdmType(aSubjectCode As %String) As %String
{
	New (aSubjectCode)
	Set return=""
	Quit:aSubjectCode="" return
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aSubjectCode)
	Quit:'$IsObject(objConfig) return
	Set ConfigID=objConfig.%Id()
	Set SubjectCode=objConfig.SubjectCode
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID,1,xItemID))
		Quit:xItemID=""
		
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set AdmType=objItem.AdmType
		Continue:AdmType=""
		
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
		Continue:'$IsObject(objItemDic)
		Set SubCatDr=objItemDic.IDSubCatDr
		Continue:'$d(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,SubCatDr))
		
		If (AdmType["I")&&(return'["I") {
			Set return=return_","_AdmType
		}
		If (AdmType["O")&&(return'["O") {
			Set return=return_","_AdmType
		}
		If (AdmType["E")&&(return'["E") {
			Set return=return_","_AdmType
		}
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

}

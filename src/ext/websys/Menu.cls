Class ext.websys.Menu Extends (%Persistent, websys.Abstract) [ Inheritance = right, Owner = {_SYSTEM}, Not ProcedureBlock ]
{

Parameter BUILD = 886;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter MAJORVERSION;

Parameter MINORVERSION;

Parameter SQLFILTER;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

ClassMethod TransCspName(TrakCspName As %String) As %String
{
	;w ##class(ext.websys.Menu).TransCspName("websys.home.csp")
	s myextcspname=""
	s mylb=$lb("websys.home.csp","websys.frames.csp","websys.default.csp","epr.frames.csp",
				"websys.closesession.csp")
	i $lf(mylb,$ZCONVERT(TrakCspName,"L"))>0{
		s myextcspname=""_TrakCspName
	}else{
		s myextcspname=TrakCspName
	}
	
	q myextcspname
}

Method JavascriptFileNameSet(val As %Library.String) As %Library.Status
{
	;s ..JavascriptFileName=val
	q $$$OK
}

/// Creates a new menu from an existing menu
/// 
/// origmenuid - the id of the original menu to copy from
/// newname - the name for the newly created menu
/// newcaption - the caption for the newly created menu
/// newid - a reference pointer to the id of the newly created menu
/// newsubmenuid - if not null, the newly created menu takes on this submenu instead of that of the original menu
ClassMethod CopyMenu(origmenuid As %String, newname As %String, newcaption As %String, ByRef newid As %String = "", newsubmenuid As %String = "", newcode As %String = "")
{
	d ##class(websys.Menu).CopyMenu()
}

ClassMethod EvaluateMethod(expression As %String) As %String
{
	;q ##class(websys.Menu).EvaluateMethod(expression)
	q @expression
}

Method EvaluateValue() As %String
{
	q ##class(websys.Menu).EvaluateValue()
}

/// Default implementation of Find Query.
ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

/// Find menus by cpation,name OR by submenuof.
ClassMethod FindExecute(ByRef QHandle As %Library.Binary, caption As %String = "", name As %String = "", submenuof As %String = "", Component As %Library.String = "", workflow As %Library.String = "") As %Library.Status
{
}

/// Default implementation of Find Query.
ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

/// Extended image.<br>
/// Treat image property as an expression to be evaluated.<br>
/// Formats include:<br>
/// Literal : webemr/rb.gif<br>
/// Function : $s(rs.GetDataByName("Type")="S":"webemr/super.gif",1:"webemr/other.gif")<br>
/// ClassMethod : ##Class(web.SomeClass).GetImage(rs.GetDataByName("Type"))<br>
Method ImageEx() As %Library.String
{
}

Method InvokeMethod()
{
}

Method LinkUrlSet(val As %Library.String) As %Library.Status
{
}

ClassMethod OpenName(name As %String) [ CodeMode = generator ]
{
}

ClassMethod ShowBar(id As %String) [ ProcedureBlock = 0 ]
{
	;w "写菜单"_"<br>",!
	;d ##Class(ext.websys.Menu).ShowBar(id)
	n (id, %session,%request)
	;s myGroupID=1
	s myGroupID=%session.Data("LOGON.GROUPID")
	;w "安全组："_myGroupID_"     "_id_"<br>",!
	;^websys.MenuI("SubMenuOf1",1012)
	s myEprGSRowID=$o(^ooGroupSettingsI("GroupDRIndex", myGroupID, 0))
	q:(myEprGSRowID="")
	
	s mySMRowID=0
	s myMenuCount=0
	s mySMSeq=0
	k myMenuArray
	;生成索引号码
	s mySMSeq=0
	f {
		s mySMSeq=$o(^websys.MenuI("SubMenuOf2",id,mySMSeq))		;;Sequence
		q:(mySMSeq="")
		s mySMRowID=0
		f {
			s mySMRowID=$o(^websys.MenuI("SubMenuOf2",id,mySMSeq, mySMRowID))
			q:(mySMRowID="")
			s myMenuCount=myMenuCount+1
			s myMenuArray(myMenuCount)=mySMRowID
		}
	}
	;画出菜单
	s mySMRowID=0
	s myMenuSeq=0
	k t
	///画表的格式
	w "<TABLE WIDTH=100%>",!
	f{
		;q:(+myMenuSeq>1)
		s myMenuSeq=$o(myMenuArray(myMenuSeq))
		q:(myMenuSeq="")
		s mySMRowID=$g(myMenuArray(myMenuSeq))
		m t=^websys.TranslationD("MENU",+$g(%session.Data("LOGON.LANGID")),mySMRowID)
		
		s myMenuObj=##Class(websys.Menu).%OpenId(mySMRowID,0)
		i $IsObject(myMenuObj){
			s myMenuName= myMenuObj.Name ;$p($g(^websys.MenuD(mySMRowID)),"^")
			s myCaption = myMenuObj.Caption
			s myShortcutKey = myMenuObj.ShortcutKey
			s myTarget = myMenuObj.Target
			s myCaption = myMenuObj.Caption
			;s myCaption=
			s myConditionalExpression = myMenuObj.ConditionalExpression
			s myImage = myMenuObj.Image
			i (myImage'=""){
				s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
				s myImage=$tr(myImage,"\","/")
				s myImage="../images/"_myImage
			}
			s myLinkUrl = myMenuObj.LinkUrl
			s myShowInNewWindow = myMenuObj.ShowInNewWindow
			s myType = myMenuObj.Type
			s myValueExpression = myMenuObj.ValueExpression
			s myJavascriptFunction = myMenuObj.JavascriptFunction
			s myValueExpression = myMenuObj.ValueExpression
			
			;判断是否有子菜单
			if +$d(^websys.MenuI("SubMenuOf1",mySMRowID)){  //wanghc 20140701
				//if ((myLinkUrl="")){
				s myChildFlag=1
			}else{
				s myChildFlag=0
			}
			
			s myValueExpression=myMenuObj.EvaluateValue()		;$p(myValueExpression,"""",2)
			i (+myChildFlag'=0){
				s myhref="#"
			}else{
				;s myPAGID=$i(^websys.Counters("tpagid"))
				;s myhref="ext.websys.csp?a=a"_myValueExpression_"&TMENU="_mySMRowID_"&TPAGID="_myPAGID
				s myhref = ##class(ext.websys.Menu).getMenuLinkURL(myMenuObj,mySMRowID)
			}
			
			s myAAttribute=""
			
			;执行Function 执行JavaScript还是执行CSP有一个判断
			i (myJavascriptFunction'=""){
				s myAAttribute="href=""javascript:"_myJavascriptFunction_"('"_myhref_"', '');"""
			}else{
				s myAAttribute="href="""_myhref_""""  ;连接
				i (myhref="#"){
					s myAAttribute=myAAttribute_" onclick=""tb_sh('tbi"_myMenuSeq_"'); return false;"""		;打开菜单
				}
				if (myTarget'=""){
					s myAAttribute=myAAttribute_" target="""_myTarget_""""		;定义目标
				}else{
					i (myhref'="#"){
						s myAAttribute=myAAttribute_" target=""TRAK_main"""		;定义目标
					}
				}
			}
			
			s:(myCaption'="") myAAttribute=myAAttribute_" title="_myCaption_""			;定义标题
			
			;定义快捷键
			s:(myShortcutKey'="") myAAttribute=myAAttribute_" accesskey="_myShortcutKey
			
			;定义图像
			s myImgAttribute="<img SRC=""../images/websys/blank.gif""  BORDER=""0"" >"
			s:(myImage'="") myImgAttribute="<img src="_myImage_" border=""0"" />"
			
			s myMenuEnable=..GetMenuSecurity(mySMRowID)
			n val
			if (+myMenuEnable){
				s val=myMenuEnable
				if (myMenuObj.ConditionalExpression'=""){
					d ##class(websys.Conversions).expressionExecute(myMenuObj.ConditionalExpression)
				}
				s myMenuEnable=val
			}
			
			if (+myMenuEnable){
				;输出当前行
				;b	;;;
				w "<TR id=""tb"_myMenuSeq_""" CLASS=""tb"">"_ "<TD NOWRAP>",!
				w "<a "_myAAttribute_">"
				w myImgAttribute
				w myCaption						;_mySMRowID_"  序号："_myMenuSeq
				w "</A>",!
				w "</TD></TR>",!
				;&&(+$d(^websys.MenuI("SubMenuOf1",mySMRowID)))
				d ..ShowBarSubExp(mySMRowID,myMenuSeq, -1, myMenuSeq)
			}
			
			d myMenuObj.%Close()
		}
	}
	w "</TABLE>", !
	w "<b>"_$ZNSPACE_"</b>",!
	w "菜单总数："_myMenuCount
	k myMenuArray
}

/// 把当前的菜单和子菜单显示出来
/// d ##Class(ext.websys.Menu).ShowBar(1)
/// Index  ^websys.MenuI("SubMenuOf1",SubItemID,RowID)
/// Index SubMenuOf1 On SubMenuOf, RowID;
/// Index SubMenuOf2 On (SubMenuOf, Sequence, RowID);
/// epr.groupsettings 
/// ^ooGroupSettingsI("GroupDRIndex", GroupDR, RowID)
/// ^ooGroupSettingsI("GroupDRIndex",1,1)
/// 使用树遍历方式
/// ShowBar   		获取菜单
/// ShowBarSub  	获取子菜单
/// ShowBarItem		获取菜单项
ClassMethod ShowBarJson(id As %String) As %String [ ProcedureBlock = 0 ]
{
	//quit "[]"
	;w "写菜单"_"<br>",!
	;d ##Class(ext.websys.Menu).ShowBarJson(1)
	
	n (id, %session, %request)
	
	;n myGroupID
	
	s myGroupID=%session.Data("LOGON.GROUPID")
	;w "安全组："_myGroupID_"     "_id_"<br>",!
	;^websys.MenuI("SubMenuOf1",1012)
	
	;zhaocz 2011-06-21 add n
	;n myAAttribute, myCaption, myConditionalExpression, myImage, myImgAttribute, myJavascriptFunction, myLinkUrl
	;n myMenuName, myShortcutKey, myShowInNewWindow, myTarget, myType, myValueExpression, myjsfunction
	
	;n myMenuObj
	;n myChildFlag
	;n myEprGSRowID, mySMRowID
	
	;n myMenuCount, myMenuEnable, myMenuSeq, mySMSeq, myhref
	
	;n myjosnstr
	
	s myEprGSRowID=$o(^ooGroupSettingsI("GroupDRIndex", myGroupID, 0))
	q:(myEprGSRowID="")
	
	s mySMRowID=0
	s myMenuCount=0
	s mySMSeq=0
	k myMenuArray
	;生成索引号码
	s mySMSeq=0
	f {
		;q:(+mySMRowID>0)
		
		
		s mySMSeq=$o(^websys.MenuI("SubMenuOf2",id,mySMSeq))		;;Sequence
		q:(mySMSeq="")
		s mySMRowID=0
		f {
			s mySMRowID=$o(^websys.MenuI("SubMenuOf2",id,mySMSeq, mySMRowID))
			q:(mySMRowID="")
			s myMenuCount=myMenuCount+1
			s myMenuArray(myMenuCount)=mySMRowID
		}
	}
	;画出菜单
	s mySMRowID=0
	s myMenuSeq=0
	k t
	
	///画表的格式
	;w "<TABLE WIDTH=100%>",!
	s myjosnstr=""
	f{
		;q:(+myMenuSeq>1)
		s myMenuSeq=$o(myMenuArray(myMenuSeq))
		q:(myMenuSeq="")
		s mySMRowID=$g(myMenuArray(myMenuSeq))
		m t=^websys.TranslationD("MENU",+$g(%session.Data("LOGON.LANGID")),mySMRowID)
		;m t=^websys.TranslationD("MENU",20,mySMRowID)
		
		s myMenuObj=##Class(websys.Menu).%OpenId(mySMRowID,0)
		i $IsObject(myMenuObj){
			s myMenuName= myMenuObj.Name ;$p($g(^websys.MenuD(mySMRowID)),"^")
			s myCaption = myMenuObj.Caption
			s myShortcutKey = myMenuObj.ShortcutKey
			s myTarget = myMenuObj.Target
			s myCaption = myMenuObj.Caption
			;s myCaption=
			s myConditionalExpression = myMenuObj.ConditionalExpression
			s myImage = myMenuObj.Image
			
			i (myImage'=""){
				s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
				s myImage=$tr(myImage,"\","/")
				s myImage="../images/"_myImage
			}
			s myLinkUrl = myMenuObj.LinkUrl
			s myShowInNewWindow = myMenuObj.ShowInNewWindow
			s myType = myMenuObj.Type
			s myValueExpression = myMenuObj.ValueExpression
			s myJavascriptFunction = myMenuObj.JavascriptFunction
			s myValueExpression = myMenuObj.ValueExpression
			
			;判断是否有子菜单
			if +$d(^websys.MenuI("SubMenuOf1",mySMRowID)){
				//if ((myLinkUrl="")){
				s myChildFlag=1
			}else{
				s myChildFlag=0
			}
			
			s myValueExpression=myMenuObj.EvaluateValue()		;$p(myValueExpression,"""",2)
			i (+myChildFlag'=0){
				s myhref=""
			}else{
				s myhref = ##class(ext.websys.Menu).getMenuLinkURL(myMenuObj,mySMRowID)
				;s myPAGID=$i(^websys.Counters("tpagid"))
				;s myhref="ext.websys.csp?a=a"_myValueExpression_"&TMENU="_mySMRowID_"&TPAGID="_myPAGID
			}
			
			s myAAttribute=""
			
			s myjsfunction=""
			;执行Function 执行JavaScript还是执行CSP有一个判断
			i (myJavascriptFunction'=""){
				s myjsfunction="javascript:"_myJavascriptFunction_"('"_myhref_"', '');"
				;s myAAttribute="javascript:"_myJavascriptFunction_"('"_myhref_"', '');"
				s myAAttribute=""
				b	;;
			}else{
				;;  href="""_myhref_"""
				s myAAttribute=myhref  ;连接
				if (myTarget'=""){
					;s myAAttribute=myAAttribute_" target="""_myTarget_""""		;定义目标
				}else{
					i (myhref'="#"){
						;s myAAttribute=myAAttribute_" target=""TRAK_main"""		;定义目标
					}
				}
			}
			
			;s:(myCaption'="") myAAttribute=myAAttribute_" title="_myCaption_""			;定义标题
			
			;定义快捷键
			;s:(myShortcutKey'="") myAAttribute=myAAttribute_" accesskey="_myShortcutKey
			
			;定义图像
			s myImgAttribute="../images/websys/blank.gif"
			s myImgAttribute=""
			s:(myImage'="") myImgAttribute=myImage
			
			n val
			s myMenuEnable=..GetMenuSecurity(mySMRowID)
			if (+myMenuEnable){
				s val=myMenuEnable
				if (myMenuObj.ConditionalExpression'=""){
					d ##class(websys.Conversions).expressionExecute(myMenuObj.ConditionalExpression)
				}
				s myMenuEnable=val
			}
			
			if (+myMenuEnable){
				;输出当前行
				;w "<TR id=""tb"_myMenuSeq_""" CLASS=""tb"">"_ "<TD NOWRAP>",!
				;w "<a "_myAAttribute_">"
				;w myImgAttribute
				;w myCaption						;_mySMRowID_"  序号："_myMenuSeq
				;w "</A>",!
				;w "</TD></TR>",!
				s:(myjosnstr'="") myjosnstr=myjosnstr_","
				
				set myjosnstr=myjosnstr_"{"
				set myjosnstr=myjosnstr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""",""qtip"":"""_myCaption_""","
				;;
				i (myAAttribute'=""){
					set myjosnstr=myjosnstr_"""href"":"""_myAAttribute_""","
				}
				set myjosnstr=myjosnstr_"""hrefTarget"":"""_$s(myTarget'="":myTarget,1:"TRAK_main")_""","
				set myjosnstr=myjosnstr_"""icon"":"""_myImgAttribute_""","
				set myjosnstr=myjosnstr_"""cls"":"""_myjsfunction_""","
				
				;,""cls"":""forum""
				i (+myChildFlag'=0)&&(+$d(^websys.MenuI("SubMenuOf1",mySMRowID))){
					set myjosnstr=myjosnstr_"""leaf"":false"
				}else{
					set myjosnstr=myjosnstr_"""leaf"":true"
				}
				
				set myjosnstr=myjosnstr_"}"
				
				;&&(+$d(^websys.MenuI("SubMenuOf1",mySMRowID)))
				;d ..ShowBarSubExpJson(mySMRowID,myMenuSeq, -1, myMenuSeq)
				;b	;;;
				
			}
			
			d myMenuObj.%Close()
		}
		
	}
	
	k myMenuArray
	s myjosnstr="["_myjosnstr_"]"
	
	q myjosnstr
}

/// 获取菜单的LinkURL 
/// add treloadid by wuqk 2011-07-13
ClassMethod getMenuLinkURL(MenuObj As %String, SMRowID As %String, treloadid As %String) As %String
{
	;w ##class(ext.websys.Menu).getMenuLinkURL()
	; zhaocz 2011-06-21 add n
	n (MenuObj,SMRowID,treloadid,%session,%request)
	
	s myhref=""
	s myhttpprefix = "http://"
	s myhttpprefix1 = "http:/"
	
	s myLinkUrl = MenuObj.LinkUrl
	s mySMRowID = SMRowID
	s myValueExpression = MenuObj.EvaluateValue()		;$p(myValueExpression,"""",2)
	;加入myLinkUrl空判断, 老库中有些菜单配置是填写了chartbook,但csp默认为空.
	i (myLinkUrl=""){
		i MenuObj.ChartBook s myLinkUrl = "epr.chartbook.csp"
		i MenuObj.Worklist s myLinkUrl="epr.worklist.csp"
		i MenuObj.LinkComponent s myLinkUrl="websys.default.csp"
	}
	i (myLinkUrl'=""){
		;s myhref=""
		;逻辑： 1 .csp  
		s mytmpurl = $zconvert(myLinkUrl,"L")
		Set SufFix=$p(mytmpurl,".",$l(mytmpurl,"."))
		if (SufFix="csp")&&(mytmpurl'["http"){
			s myChartID=""
			if ($IsObject(MenuObj.Chart)){
				s myChartID=MenuObj.Chart.%Id()
			}
			s myChartBookID=""
			if ($IsObject(MenuObj.ChartBook)){
				s myChartBookID=MenuObj.ChartBook.%Id()
			}
			s mychartstr=""
			if (myChartID'=""){
				s mychartstr="&ChartID="_myChartID
			}
			if (myChartBookID'=""){
				s mychartstr=mychartstr_"&ChartBookID="_myChartBookID
			}
			s myPAGID=$i(^websys.Counters("tpagid"))
			s myhref="websys.csp?a=a"_myValueExpression_"&TMENU="_mySMRowID_"&TPAGID="_myPAGID
			s:$g(treloadid) myhref=myhref_"&TRELOADID="_treloadid   // add by wuqk 2011-07-13
			s myhref=myhref_mychartstr
			if (MenuObj.ShowInNewWindow'="") Set myhref = myhref_"&SwitchSysPat=N"
		}elseif (SufFix="exe"){ //以exe结尾
			s myhref=myLinkUrl
		}elseif(SufFix="application"){
			s myhref=myLinkUrl
		}else{
			s myhref=myLinkUrl
			/*
			;逻辑： 2  http://   javascript
			if (mytmpurl[myhttpprefix){
				s myhref=myLinkUrl
			}elseif (mytmpurl["javascript"){   //add by wuqk  2011-08-10
				s myhref = myLinkUrl
			}elseif (mytmpurl[myhttpprefix1){
				s myhref = myhttpprefix_$p(mytmpurl,myhttpprefix1,2)
			}else{
				if ($l(mytmpurl,"/")>2){
					; 独立网站
					s myhref = myhttpprefix_""_myLinkUrl
				}else{
					s myhref = %request.URLPrefix_""_myLinkUrl
				}
			}*/
		}
	}
	q myhref
}

/// 层次关系
/// 层的索引号码
ClassMethod ShowBarSubExp(id As %String, j As %String, sublevel As %Integer, sublevelidx As %Integer = 0) As %String [ ProcedureBlock = 1 ]
{
	s sublevel=sublevel+1
	s mySMSeq=0
	s myMenuCount=0
	k myMenuArray
	f {
		s mySMSeq=$o(^websys.MenuI("SubMenuOf2",id,mySMSeq))		;;Sequence
		q:(mySMSeq="")
		s mySMRowID=0
		f {
			s mySMRowID=$o(^websys.MenuI("SubMenuOf2",id,mySMSeq, mySMRowID))
			q:(mySMRowID="")
			s myMenuCount=myMenuCount+1
			s myMenuArray(myMenuCount)=mySMRowID
		}
	}
	
	i +sublevel'=0{
		w "<TABLE>"
	}
	
	i +sublevel=0{
		s myMenuSeqStr=j
	}else{
		s myMenuSeqStr=j_"_"_sublevel_"_"_sublevelidx
	}
	
	w "<TR ID=""tbi"_myMenuSeqStr_""" CLASS=""tbihide"">",!
	w "<TD NOWRAP>",!
	s mySubMenuSeq=0
	f {
		s sublevelidx=+sublevelidx+1
		s mySubMenuSeq=$o(myMenuArray(mySubMenuSeq))
		q:(mySubMenuSeq="")
		s mySMRowID=$g(myMenuArray(mySubMenuSeq))

		s myMenuObj=##Class(websys.Menu).%OpenId(mySMRowID)
		i $IsObject(myMenuObj){
			s myMenuName= myMenuObj.Name ;$p($g(^websys.MenuD(mySMRowID)),"^")
			s myCaption = myMenuObj.Caption
			s myShortcutKey = myMenuObj.ShortcutKey
			s myTarget = myMenuObj.Target
			s myCaption = myMenuObj.Caption
			s myConditionalExpression = myMenuObj.ConditionalExpression
			s myImage = myMenuObj.Image
			i (myImage'=""){
				s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
				s myImage=$tr(myImage,"\","/")
				s myImage="../images/"_myImage
			}
			s myLinkUrl = myMenuObj.LinkUrl
			s myShowInNewWindow = myMenuObj.ShowInNewWindow
			s myType = myMenuObj.Type
			s myValueExpression = myMenuObj.ValueExpression
			s myJavascriptFunction = myMenuObj.JavascriptFunction
			s myValueExpression = myMenuObj.ValueExpression
			
			;判断是否有子菜单 !('$IsObject(myMenuObj.LinkComponent))
			if +$d(^websys.MenuI("SubMenuOf1",thisId)){ //wanghc 20140701		
				//if ((myLinkUrl="")){
				s myChildFlag=1
			}else{
				s myChildFlag=0
			}
			
			s myValueExpression=myMenuObj.EvaluateValue()		;$p(myValueExpression,"""",2)
			
			i (+myChildFlag'=0){
				s myhref="#"
			}else{
				s myhref = ##class(ext.websys.Menu).getMenuLinkURL(myMenuObj,mySMRowID)
				;s myPAGID=$i(^websys.Counters("tpagid"))
				;s myhref="ext.websys.csp?a=a"_myValueExpression_"&TMENU="_mySMRowID_"&TPAGID="_myPAGID
			}
			
			s myAAttribute=""
			
			if (myJavascriptFunction'=""){
				s myAAttribute="href=""javascript:"_myJavascriptFunction_"('"_myhref_"', '');"""
			}else{
				s myAAttribute="href="""_myhref_""""  ;连接
				s mySubMenuSeqStr=j_"_"_(sublevel+1)_"_"_sublevelidx
				i (myhref="#"){
					s myAAttribute=myAAttribute_" onclick=""tb_sh('tbi"_mySubMenuSeqStr_"'); return false;"""		;打开菜单
				}
				if (myTarget'=""){
					s myAAttribute=myAAttribute_" target="""_myTarget_""""		;定义目标
				}else{
					i (myhref'="#"){
						s myAAttribute=myAAttribute_" target=""TRAK_main"""		;定义目标
					}
				}
			}
			s:(myCaption'="") myAAttribute=myAAttribute_" title="_myCaption_""			;定义标题
			
			;定义快捷键
			s:(myShortcutKey'="") myAAttribute=myAAttribute_" accesskey="_myShortcutKey
			
			;定义图像
			s myImgAttribute="<img SRC=""../images/websys/blank.gif""  BORDER=""0"" >"
			s:(myImage'="") myImgAttribute="<img src="_myImage_" border=""0"" />"
			
			s myMenuEnable=..GetMenuSecurity(mySMRowID)
			if (+myMenuEnable){
				s val=myMenuEnable
				if (myMenuObj.ConditionalExpression'=""){
					d ##class(websys.Conversions).expressionExecute(myMenuObj.ConditionalExpression)
				}
				s myMenuEnable=val
			}
			
			;判断权限，是否显示
			i (+myMenuEnable){
				;输出当前行
				w "<a "_myAAttribute_">"
				w myImgAttribute
				w myCaption						;_mySMRowID_"  序号："_myMenuSeq
				w "</A>",!
				w "<BR>",!
				;(id As %String, j As %String, sublevel As %Integer, sublevelidx As %Integer=0)
				i ((+myChildFlag'=0)&&(+$d(^websys.MenuI("SubMenuOf1",mySMRowID)))){
					d ..ShowBarSubExp(mySMRowID,j,  sublevel, .sublevelidx)
				}
			}
			
			d myMenuObj.%Close()
		}
		
	}
	
	w "</TD></TR>",!
	i +sublevel'=0{
		w "</TABLE>"
	}
	
	k myMenuArray
	;
}

/// sublevel  定义菜单的层级
ClassMethod ShowBarSubExpJson(id As %String, j As %String, sublevel As %Integer, sublevelidx As %Integer = 0) As %String [ ProcedureBlock = 1 ]
{
	s sublevel=sublevel+1
	s mySMSeq=0
	s myMenuCount=0
	k myMenuArray
	f {
		s mySMSeq=$o(^websys.MenuI("SubMenuOf2",id,mySMSeq))		;;Sequence
		q:(mySMSeq="")
		s mySMRowID=0
		f {
			s mySMRowID=$o(^websys.MenuI("SubMenuOf2", id, mySMSeq, mySMRowID))
			q:(mySMRowID="")
			s myMenuCount=myMenuCount+1
			s myMenuArray(myMenuCount)=mySMRowID
		}
	}
	
	i +sublevel'=0{
		
	}
	
	i +sublevel=0{
		s myMenuSeqStr=j
	}else{
		s myMenuSeqStr=j_"_"_sublevel_"_"_sublevelidx
	}
		
	s myjosnstr=""
	s mySubMenuSeq=0
	f {
		s sublevelidx=+sublevelidx+1
		s mySubMenuSeq=$o(myMenuArray(mySubMenuSeq))
		q:(mySubMenuSeq="")
		s mySMRowID=$g(myMenuArray(mySubMenuSeq))
		
		s myMenuObj=##Class(websys.Menu).%OpenId(mySMRowID)
		i $IsObject(myMenuObj){
			s myMenuName= myMenuObj.Name 		;$p($g(^websys.MenuD(mySMRowID)),"^")
			s myCaption = myMenuObj.Caption
			s myShortcutKey = myMenuObj.ShortcutKey
			s myTarget = myMenuObj.Target
			s myCaption = myMenuObj.Caption
			s myConditionalExpression = myMenuObj.ConditionalExpression
			s myImage = myMenuObj.Image
			i (myImage'=""){
				s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
				s myImage=$tr(myImage,"\","/")
				s myImage="../images/"_myImage
			}
			s myLinkUrl = myMenuObj.LinkUrl
			s myShowInNewWindow = myMenuObj.ShowInNewWindow
			s myType = myMenuObj.Type
			s myValueExpression = myMenuObj.ValueExpression
			s myJavascriptFunction = myMenuObj.JavascriptFunction
			s myValueExpression = myMenuObj.ValueExpression
			
			;判断是否有子菜单 !('$IsObject(myMenuObj.LinkComponent))
			if +$d(^websys.MenuI("SubMenuOf1",mySMRowID)){		
				//wanghc 20140701 子菜单的url可能是空,通过索引判断
				//if ((myLinkUrl="")){
				s myChildFlag=1
			}else{
				s myChildFlag=0
			}
			
			s myValueExpression=myMenuObj.EvaluateValue()		;$p(myValueExpression,"""",2)
			
			i (+myChildFlag'=0){
				s myhref = ""
			}else{
				s myhref = ##class(ext.websys.Menu).getMenuLinkURL(myMenuObj,mySMRowID)
				;s myPAGID=$i(^websys.Counters("tpagid"))
				;s myhref="ext.websys.csp?a=a"_myValueExpression_"&TMENU="_mySMRowID_"&TPAGID="_myPAGID
			}
			
			s myAAttribute=""
			
			s myAAttribute=""
			
			s myjsfunction=""
			s myAAttribute=myhref  ;连接    //add by wuqk 2011-03-30  //add 2011-07-14
			
			;执行Function 执行JavaScript还是执行CSP有一个判断
			i (myJavascriptFunction'=""){
				//modify by wuqk 2011-03-30
				//s myjsfunction="javascript:"_myJavascriptFunction_"('"_myhref_"', '');"
				s myjsfunction=myJavascriptFunction_"('"_myhref_"', '"_myShowInNewWindow_"');"
				s myAAttribute=""
			}
			elseif (myShowInNewWindow'=""){  //add by wuqk 2011-03-29
				s myjsfunction=myjsfunction_"websys_lu('"_myhref_"',false,'"_myShowInNewWindow_"');"
				s myAAttribute=""
			}
			i (myjsfunction'=""){
				s myjsfunction="javascript:"_myjsfunction
			}
			/*   // removed by wuqk 2011-03-30
			else{
				;;  href="""_myhref_"""
				s myAAttribute=myhref  ;连接
				if (myTarget'=""){
					
				}else{
					i (myhref'="#"){
						
					}
				}
			}*/
			/*   //removed by wuqk 2011-07-14
			s myjsfunction=""
			;执行Function 执行JavaScript还是执行CSP有一个判断
			i (myJavascriptFunction'=""){
				s myjsfunction="javascript:"_myJavascriptFunction_"('"_myhref_"', '');"
				;s myAAttribute="javascript:"_myJavascriptFunction_"('"_myhref_"', '');"
				s myAAttribute=""
				
			}else{
				;;  href="""_myhref_"""
				s myAAttribute=myhref  ;连接
				if (myTarget'=""){
					
				}else{
					i (myhref'="#"){
						
					}
				}
			}*/
			
			;定义图像
			s myImgAttribute=""
			s myImgAttribute=""
			s:(myImage'="") myImgAttribute=myImage
			
			s myMenuEnable=..GetMenuSecurity(mySMRowID)
			if (+myMenuEnable){
				s val=myMenuEnable
				if (myMenuObj.ConditionalExpression'=""){
					d ##class(websys.Conversions).expressionExecute(myMenuObj.ConditionalExpression)
				}
				s myMenuEnable=val
			}
			
			;s myMenuEnable=1
			;判断权限，是否显示
			i (+myMenuEnable){
				
				s:(myjosnstr'="") myjosnstr=myjosnstr_","
				
				set myjosnstr=myjosnstr_"{"
				set myjosnstr=myjosnstr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
				;;
				i (myAAttribute'=""){
					set myjosnstr=myjosnstr_"""href"":"""_myAAttribute_""","
				}
				set myjosnstr=myjosnstr_"""hrefTarget"":"""_$s(myTarget'="":myTarget,1:"TRAK_main")_""","
				set myjosnstr=myjosnstr_"""icon"":"""_myImgAttribute_""","
				set myjosnstr=myjosnstr_"""cls"":"""_myjsfunction_""","
				
				;,""cls"":""forum""
				i ((+myChildFlag'=0)&&(+$d(^websys.MenuI("SubMenuOf1",mySMRowID)))){
					set myjosnstr=myjosnstr_"""leaf"":false,"
					s myjosnstr=myjosnstr_"""children"":"_"["
					s mysubjsonstr=..ShowBarSubExpJson(mySMRowID,j,  sublevel, .sublevelidx)
					s myjosnstr=myjosnstr_mysubjsonstr
					s myjosnstr=myjosnstr_"]"
				}else{
					set myjosnstr=myjosnstr_"""leaf"":true"
				}
				
				set myjosnstr=myjosnstr_"}"
				
				;(id As %String, j As %String, sublevel As %Integer, sublevelidx As %Integer=0)
			}
			
			d myMenuObj.%Close()
		}
		
	}
	
	;w "</TD></TR>",!
	i +sublevel'=0{
		;w "</TABLE>"
	}
	
	k myMenuArray
	
	q myjosnstr
	;
}

/// d ##class(ext.websys.Menu).ShowBarSub(1,"",1,0)
/// 
ClassMethod ShowBarSub(id As %String, j As %String, sublevel As %Integer, sublevelidx As %Integer = 0)
{
	
	d ..ShowBarSubExp()
	d ##class(websys.Menu).ShowBarSub(id,j,sublevel,sublevelidx)
	;
}

/// Log 51261 - AI - 30-08-2005 : Modified Method to include reportmanagerdsn and configmanagerdsn.
ClassMethod ShowBarItem(top As %String, cnt As %String, menuid As %String, sublevel As %Integer = 0, ByRef JSfiles As %String)
{
	; top
	; cnt
	; menuid
	; sublevel
	; JSfiles
}

/// Log 51261 - AI - 30-08-2005 : Modified Method to include reportmanagerdsn and configmanagerdsn.
ClassMethod ShowMenuMS(menulist As %String, title As %String = "", componentid As %Library.String = "", componentname As %Library.String = "")
{
}

/// 获取
ClassMethod GetMainMenuJosn() As %String
{
	; zhaocz 2011-06-21 修正 n
	n (%session, %request)
	
	s menu=##Class(epr.GroupSettings).GetMainMenu(%session.Get("LOGON.GROUPID"),.swf)
	i menu="" ;
	s myjsonstr=##Class(ext.websys.Menu).ShowToolBarJosn(menu)
	q myjsonstr
}

ClassMethod ShowToolBarJosn(id As %Library.String) [ ProcedureBlock = 0 ]
{
	;d ##class(ext.websys.Menu).ShowToolBarJosn(1073)
	n (id, %session, %request)
	
	s myGroupID=%session.Data("LOGON.GROUPID")
	;w "安全组："_myGroupID_"     "_id_"<br>",!
	;^websys.MenuI("SubMenuOf1",1012)
	s myEprGSRowID=$o(^ooGroupSettingsI("GroupDRIndex", myGroupID, 0))
	q:(myEprGSRowID="")
	
	s myEGSObj=##class(epr.GroupSettings).%OpenId(myEprGSRowID, 0)
	s myGroupMenuSecurity = myEGSObj.MenuSecurity
	
	d myEGSObj.%Close()

	s mySMRowID=0
	s myMenuCount=0
	s mySMSeq=0
	k myMenuArray
	
	s mymjosnstr=""
	
	s mySMSeq=0
	f {
		s mySMSeq=$o(^websys.MenuI("SubMenuOf2",id,mySMSeq))		;;Sequence
		q:(mySMSeq="")
		s mySMRowID=0
		f {
			s mySMRowID=$o(^websys.MenuI("SubMenuOf2",id,mySMSeq, mySMRowID))
			q:(mySMRowID="")
			s myMenuCount=myMenuCount+1
			s myMenuArray(myMenuCount)=mySMRowID
		}
	}
	
	s myMenuSeq=0
	s mySMRowID=""
	f{
		;q:(+myMenuSeq>1)
		s myMenuSeq=$o(myMenuArray(myMenuSeq))
		q:(myMenuSeq="")
		s mySMRowID=$g(myMenuArray(myMenuSeq))
		
		;;s myMenuEnable=..GetMenuSecurity(mySMRowID)
		s myMenuEnable=0
		s myMenuSecurity=myGroupMenuSecurity		;$g(%session.Data("LOGON.GROUPMENUS"))
		i myMenuSecurity="" s myMenuEnable=0 i 1
		e  i $zbitlen(myMenuSecurity)<mySMRowID s myMenuEnable=0 i 1
		e  s myMenuEnable=$s($zbitget(myMenuSecurity,mySMRowID):1,1:0)
		
		i (myMenuEnable){
			
			s myitemstr=..ShowToolBarItemJson(id,myMenuSeq,mySMRowID,.jsfiles)
			s:(mymjosnstr'="") mymjosnstr=mymjosnstr_","
			s mymjosnstr=mymjosnstr_myitemstr
			
		}
	}
	
	s mymjosnstr="["_mymjosnstr_"]"
	
	q mymjosnstr
	;
}

/// 
///    菜单上的图标定义需要传递ID ChartID=34&ChartBookID=4
ClassMethod ShowToolBarItemJson(top As %Library.String, cnt As %Library.String, menuid As %Library.String, ByRef JSfiles As %String) As %String
{
	; top 
	; cnt 
	; menuid
	; JSfiles
	;n (top, cnt, menuid,JSfiles)
	
	k t
	s JSfiles=""
	m t=^websys.TranslationD("MENU",+$g(%session.Data("LOGON.LANGID")),menuid)
	s mymenujosn=""
	
	s myMenuObj=##Class(websys.Menu).%OpenId(menuid,0)
	i $IsObject(myMenuObj){
		s myMenuName= myMenuObj.Name ;$p($g(^websys.MenuD(mySMRowID)),"^")
		s myCaption = myMenuObj.Caption
		s myShortcutKey = myMenuObj.ShortcutKey
		s myTarget = myMenuObj.Target
		s myCaption = myMenuObj.Caption
		;s myCaption=
		s myConditionalExpression = myMenuObj.ConditionalExpression
		s myImage = myMenuObj.Image
		
		i (myImage'=""){
			s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
			s myImage=$tr(myImage,"\","/")
			s myImage="../images/"_myImage
		}
		s myLinkUrl = myMenuObj.LinkUrl
		s myShowInNewWindow = myMenuObj.ShowInNewWindow
		s myType = myMenuObj.Type
		s myValueExpression = myMenuObj.ValueExpression
		s myJavascriptFunction = myMenuObj.JavascriptFunction
		s myValueExpression = myMenuObj.ValueExpression
		
		s myChartID=""
		if ($IsObject(myMenuObj.Chart)){
			s myChartID=myMenuObj.Chart.%Id()
		}
		
		s myChartBookID=""
		if ($IsObject(myMenuObj.ChartBook)){
			s myChartBookID=myMenuObj.ChartBook.%Id()
		}
		
		s myValueExpression=myMenuObj.EvaluateValue()		;$p(myValueExpression,"""",2)
		
		s myChildFlag=0		;没有下级菜单
		if +$d(^websys.MenuI("SubMenuOf1",menuid)){ //wanghc 20140701
			//if ((myLinkUrl="")){
			s myChildFlag=1
		}else{
			s myChildFlag=0
		}
		;ChartID=34&ChartBookID=4
		s mychartstr=""
		if (myChartID'=""){
			s mychartstr="&ChartID="_myChartID
		}
		if (myChartBookID'=""){
			s mychartstr=mychartstr_"&ChartBookID="_myChartBookID
		}
		
		s myhref=""
		
		;i (myLinkUrl'="") {
			;s myPAGID=$i(^websys.Counters("tpagid"))
			;s myhref="ext.websys.csp?a=a"_myValueExpression_"&TMENU="_menuid_"&TPAGID="_myPAGID_mychartstr
			s myhref = ##class(ext.websys.Menu).getMenuLinkURL(myMenuObj,mySMRowID)
		;}
		
		s myAAttribute=""
		
		s myAAttribute=myhref  ;连接    //add by wuqk 2011-04-29
		;执行Function 执行JavaScript还是执行CSP有一个判断
		i (myJavascriptFunction'=""){
			//modify by wuqk 2011-03-30
			//s myjsfunction="javascript:"_myJavascriptFunction_"('"_myhref_"', '');"
			s myAAttribute="javascript:"_myJavascriptFunction_"('"_myhref_"', '"_myShowInNewWindow_"');"
			//s myAAttribute=""
		}
		elseif (myShowInNewWindow'=""){  //add by wuqk 2011-03-29
			s myAAttribute="javascript:websys_lu('"_myhref_"',false,'"_myShowInNewWindow_"');" //myjsfunction_ wuqk 2011-05-17
			//s myAAttribute=""
		}
		
		/* removed by wuqk 2011-04-29
		;执行Function 执行JavaScript还是执行CSP有一个判断
		i (myJavascriptFunction'=""){
			s myAAttribute="javascript:"_myJavascriptFunction_"('"_myhref_"', '');"
			
		}else{
			s myAAttribute=""_myhref_""  ;连接
			;s myAAttribute=myAAttribute_" onclick=""SelectToolbar('tbi"_cnt_"');"""		;打开菜单
			if (myTarget'=""){
				;s myAAttribute=myAAttribute_" target="""_myTarget_""""		;定义目标
			}else{
				i (myhref'="#"){
					;s myAAttribute=myAAttribute_" target=""TRAK_main"""		;定义目标
				}
			}
		}
		*/
		/*     //removed by wuqk 2011-07-14
		;执行Function 执行JavaScript还是执行CSP有一个判断
		i (myJavascriptFunction'=""){
			s myAAttribute="javascript:"_myJavascriptFunction_"('"_myhref_"', '');"
			
		}else{
			s myAAttribute=""_myhref_""  ;连接
			;s myAAttribute=myAAttribute_" onclick=""SelectToolbar('tbi"_cnt_"');"""		;打开菜单
			if (myTarget'=""){
				;s myAAttribute=myAAttribute_" target="""_myTarget_""""		;定义目标
			}else{
				i (myhref'="#"){
					;s myAAttribute=myAAttribute_" target=""TRAK_main"""		;定义目标
				}
			}
		}
		*/
		;s:(myCaption'="") myAAttribute=myAAttribute_" title="_myCaption_""			;定义标题
		
		s myShowShortcutKey=""
		
		;定义快捷键
		;s:(myShortcutKey'="") myAAttribute=myAAttribute_" accesskey="_myShortcutKey
		
		;在页面上显示快捷键
		;s:(myShortcutKey'="") myShowShortcutKey="<U>"_myShortcutKey_"</U>"
		
		;定义图像
		s myImgAttribute=""
		s:(myImage'="") myImgAttribute=myImage
		
		;输出当前行
		;w "<TD id=""tb"_cnt_""" class=""tb"" NOWRAP>",!
		;w "<a "_myAAttribute_">"
		;w myImgAttribute
		;w myCaption_myShowShortcutKey						;_mySMRowID_"  序号："_myMenuSeq
		;w "</a>",!
		;w "</TD>",!
		;w "<DIV ID=""tbi"_cnt_""" class=""tlbar"" style=""visibility:hidden;"">"
		;w "</DIV>"
		
		s myjosnstr="{"
		set myjosnstr=myjosnstr_"""id"":"""_""_menuid_""",""text"":"""_myCaption_""","
		
		i (myAAttribute'=""){
			set myjosnstr=myjosnstr_"""href"":"""_myAAttribute_""","
		}
		set myjosnstr=myjosnstr_"""hrefTarget"":"""_$s(myTarget'="":myTarget,1:"TRAK_main")_""","
		set myjosnstr=myjosnstr_"""icon"":"""_myImgAttribute_""","
		
		;,""cls"":""forum""
		i +myChildFlag=0{
			set myjosnstr=myjosnstr_"""leaf"":true"
		}else{
			set myjosnstr=myjosnstr_"""leaf"":false"
			;有叶子调用 
			set myjosnstr=myjosnstr_",""children"":["
			b	;
			s mysbsubjsonstr=..ShowBarSubExpJson(menuid,myMenuSeq, -1, myMenuSeq)
			set myjosnstr=myjosnstr_mysbsubjsonstr
			set myjosnstr=myjosnstr_"]"
			
			b	;mysbsubjsonstr
		}
		
		set myjosnstr=myjosnstr_"}"
		
		d myMenuObj.%Close()
		
		q myjosnstr
	}
}

/// Displays a menu across the page.
/// 本方法被用来显示头菜单 ext.epr.menu.csp
/// 步骤：1. 取出本安全组的头菜单授权
///       2. 取出id 的子菜单
/// 		  3. 画出菜单
ClassMethod ShowToolBar(id As %Library.String) [ ProcedureBlock = 0 ]
{
	;d ##class(ext.websys.Menu).ShowToolBar(1073)
	;d ##class(websys.Menu).ShowToolBar(id)
	;q 
	s myGroupID=%session.Data("LOGON.GROUPID")
	;w "安全组："_myGroupID_"     "_id_"<br>",!
	;^websys.MenuI("SubMenuOf1",1012)
	s myEprGSRowID=$o(^ooGroupSettingsI("GroupDRIndex", myGroupID, 0))
	q:(myEprGSRowID="")
	
	s myEGSObj=##class(epr.GroupSettings).%OpenId(myEprGSRowID, 0)
	s myGroupMenuSecurity = myEGSObj.MenuSecurity
	
	d myEGSObj.%Close()

	s mySMRowID=0
	s myMenuCount=0
	s mySMSeq=0
	k myMenuArray
	
	s mySMSeq=0
	f {
		s mySMSeq=$o(^websys.MenuI("SubMenuOf2",id,mySMSeq))		;;Sequence
		q:(mySMSeq="")
		s mySMRowID=0
		f {
			s mySMRowID=$o(^websys.MenuI("SubMenuOf2",id,mySMSeq, mySMRowID))
			q:(mySMRowID="")
			s myMenuCount=myMenuCount+1
			s myMenuArray(myMenuCount)=mySMRowID
		}
	}
	
	w "<TABLE width='100%' id='tablemenu'>",!
	w "<TR>",!
	
	s myMenuSeq=0
	s mySMRowID=""
	f{
		;q:(+myMenuSeq>1)
		s myMenuSeq=$o(myMenuArray(myMenuSeq))
		q:(myMenuSeq="")
		s mySMRowID=$g(myMenuArray(myMenuSeq))
		
		;;s myMenuEnable=..GetMenuSecurity(mySMRowID)
		s myMenuEnable=0
		s myMenuSecurity=myGroupMenuSecurity		;$g(%session.Data("LOGON.GROUPMENUS"))
		i myMenuSecurity="" s myMenuEnable=0 i 1
		e  i $zbitlen(myMenuSecurity)<mySMRowID s myMenuEnable=0 i 1
		e  s myMenuEnable=$s($zbitget(myMenuSecurity,mySMRowID):1,1:0)
		
		i (myMenuEnable){
			d ..ShowToolBarItem(id,myMenuSeq,mySMRowID, .jsfiles)
		}
	}
	
	w "</TR>",!
	w "</TABLE>",!
	
	;
}

/// 显示Tool bar 项目
ClassMethod ShowToolBarItem(top As %Library.String, cnt As %Library.String, menuid As %Library.String, ByRef JSfiles As %String)
{
	; top 
	; cnt 
	; menuid
	; JSfiles
	k t
	s JSfiles=""
	m t=^websys.TranslationD("MENU",+$g(%session.Data("LOGON.LANGID")),menuid)
	
	s myMenuObj=##Class(websys.Menu).%OpenId(menuid,0)
	i $IsObject(myMenuObj){
		s myMenuName= myMenuObj.Name ;$p($g(^websys.MenuD(mySMRowID)),"^")
		s myCaption = myMenuObj.Caption
		s myShortcutKey = myMenuObj.ShortcutKey
		s myTarget = myMenuObj.Target
		s myCaption = myMenuObj.Caption
		b	;;caption
		;s myCaption=
		s myConditionalExpression = myMenuObj.ConditionalExpression
		s myImage = myMenuObj.Image
		i (myImage'=""){
			s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
			s myImage=$tr(myImage,"\","/")
			s myImage="../images/"_myImage
		}
		s myLinkUrl = myMenuObj.LinkUrl
		s myShowInNewWindow = myMenuObj.ShowInNewWindow
		s myType = myMenuObj.Type
		s myValueExpression = myMenuObj.ValueExpression
		s myJavascriptFunction = myMenuObj.JavascriptFunction
		s myValueExpression = myMenuObj.ValueExpression
		
		s myValueExpression=myMenuObj.EvaluateValue()		;$p(myValueExpression,"""",2)
		
		;s myPAGID=$i(^websys.Counters("tpagid"))
		;s myhref="ext.websys.csp?a=a"_myValueExpression_"&TMENU="_menuid_"&TPAGID="_myPAGID
		s myhref = ##class(ext.websys.Menu).getMenuLinkURL(myMenuObj,menuid)
		
		s myAAttribute=""
		
		;执行Function 执行JavaScript还是执行CSP有一个判断
		i (myJavascriptFunction'=""){
			s myAAttribute="href=""javascript:"_myJavascriptFunction_"('"_myhref_"', '');"""
			
		}else{
			s myAAttribute="href="""_myhref_""""  ;连接
			;i (myhref="#"){
			s myAAttribute=myAAttribute_" onclick=""SelectToolbar('tbi"_cnt_"');"""		;打开菜单
			;}
			if (myTarget'=""){
				s myAAttribute=myAAttribute_" target="""_myTarget_""""		;定义目标
			}else{
				i (myhref'="#"){
					s myAAttribute=myAAttribute_" target=""TRAK_main"""		;定义目标
				}
			}
		}
		
		s:(myCaption'="") myAAttribute=myAAttribute_" title="_myCaption_""			;定义标题
		
		s myShowShortcutKey=""
		
		;定义快捷键
		s:(myShortcutKey'="") myAAttribute=myAAttribute_" accesskey="_myShortcutKey
		
		s:(myShortcutKey'="") myShowShortcutKey="<U>"_myShortcutKey_"</U>"
		
		;定义图像
		s myImgAttribute=""
		s:(myImage'="") myImgAttribute="<img src="_myImage_" border=""0"" />"
		
		;输出当前行
		w "<TD id=""tb"_cnt_""" class=""tb"" NOWRAP>",!
		w "<a "_myAAttribute_">"
		w myImgAttribute
		w myCaption_myShowShortcutKey						;_mySMRowID_"  序号："_myMenuSeq
		w "</a>",!
		w "</TD>",!
		w "<DIV ID=""tbi"_cnt_""" class=""tlbar"" style=""visibility:hidden;"">"
		w "</DIV>"
		
		d myMenuObj.%Close()
	}
}

ClassMethod VBFindLEClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = VBFindLEFetch ]
{
}

ClassMethod VBFindLEExecute(ByRef QHandle As %Library.Binary, desc As %Library.String) As %Library.Status
{
}

ClassMethod VBFindLEFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = VBFindLEExecute ]
{
}

/// Get the ID from the identified by string.
/// By default the generated version of this returns the value passed.
/// In general this method will be overridden to provide the required behaviour.
/// For example - Component name is passed - this will return ..%Id()
ClassMethod XMLId(val As %Library.String) As %Library.String
{
}

Method XMLPreference()
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSaveCopyHeaders(newcode As %Library.String)
{
}

/// Find Menus by name and caption prefix OR by submenuof
Query Find(caption As %String, name As %String, submenuof As %String, Component As %String, workflow As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Caption,Name,SubMenuOf,SubMenuOfName,Workflow,ReportID,ReportDescription,Sequence:%String,ShortcutKey:%String")
{
}

ClassMethod FindCapByLinkUrlBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query VBFindLE(desc As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Description:%Library.String,UpdateDate:%String,UpdateTime:%String")
{
}

ClassMethod PatientSearchLink() As %Library.String
{
}

ClassMethod PatientSearchStore(cmpname As %Library.String)
{
}

ClassMethod PatientSearchRetrieve()
{
	d ##class(websys.Menu).PatientSearchRetrieve()
}

/// 获取菜单是否显示的权限 
/// =0 不显示
/// =1 显示
/// 保存的 选择项的最大RowID值，
ClassMethod GetMenuSecurity(Id As %String) As %String
{
	;zhaocz 2011-06-21 add n
	n myMenuSecurity, enabled
	
	s enabled=0
	s myMenuSecurity=$g(%session.Data("LOGON.GROUPMENUS"))
	i myMenuSecurity="" s enabled=0 i 1
	e  i $zbitlen(myMenuSecurity)<Id s enabled=0 i 1
	e  s enabled=$s($zbitget(myMenuSecurity,Id):1,1:0)
	q enabled
}

Storage Default
{
<Data name="MenuDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^ext.websys.MenuD</DataLocation>
<DefaultData>MenuDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ext.websys.MenuD</IdLocation>
<IndexLocation>^ext.websys.MenuI</IndexLocation>
<StreamLocation>^ext.websys.MenuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class web.DHCSTMHUI.Menu Extends %RegisteredObject [ Owner = {_SYSTEM}, Not ProcedureBlock ]
{

/// Descript:	生成菜单JSON串，递归子菜单
/// Creator:	XuChao Update
/// CreateDate:	2018-03-16
/// Input:		菜单id
/// Return：	JSON串
/// w ##Class(web.DHCSTMHUI.Menu).ShowBarJson(57762)
ClassMethod ShowBarJson(id As %String, filter = "", showFlag = "") As %String
{
	n (id,filter,showFlag,%session)
	s showFlag=""		;递归传递
	s myGroupID=%session.Data("LOGON.GROUPID")
	s myEprGSRowID=$o(^ooGroupSettingsI("GroupDRIndex", myGroupID, 0))
	q:(myEprGSRowID="")
	s mySMRowID=0
	s myMenuCount=0
	s mySMSeq=0
	k myMenuArray
	;生成索引号码
	s mySMSeq=0
	f {
		s mySMSeq=$o(^websys.MenuI("SubMenuOf2",id,mySMSeq))
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
	s myjosnstr=""
	f{
		s returnShowFlag="" ;递归返回
		s myMenuSeq=$o(myMenuArray(myMenuSeq))
		q:(myMenuSeq="")
		s mySMRowID=$g(myMenuArray(myMenuSeq))
		s myMenuObj=##Class(websys.Menu).%OpenId(mySMRowID,0)
		i $IsObject(myMenuObj){
			s myMenuName= myMenuObj.Name 
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
			
			;判断是否有子菜单
			if ((myLinkUrl="")){
				s myChildFlag=1
			}else{
				s myChildFlag=0
			}
			
			s myValueExpression=myMenuObj.EvaluateValue()
			i (+myChildFlag'=0){
				s myhref=""
			}else{
				s myhref ="dhcstmhui.menu.csp?MENU="_mySMRowID
			}
			
			s myAAttribute=""
			
			s myjsfunction=""
			;执行Function 执行JavaScript还是执行CSP有一个判断
			i (myJavascriptFunction'=""){
				s myjsfunction="javascript:"_myJavascriptFunction_"('"_myhref_"', '');"
				s myAAttribute=""
			}else{
				s myAAttribute=myhref_myValueExpression		;连接表达式
			}
			
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
				s tmpjsonstr=""
				set tmpjsonstr=tmpjsonstr_"{"
				set tmpjsonstr=tmpjsonstr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
				i (myAAttribute'=""){
					set tmpjsonstr=tmpjsonstr_"""myhref"":"""_myAAttribute_""","
				}
				i (+myChildFlag'=0){
					set tmpjsonstr=tmpjsonstr_"""children"":"
					s child=..ShowBarJson(mySMRowID,filter,.returnShowFlag)
					set tmpjsonstr=tmpjsonstr_child_","
					}
				set tmpjsonstr=tmpjsonstr_"""icon"":"""_myImgAttribute_""","
				set tmpjsonstr=tmpjsonstr_"""cls"":"""_myjsfunction_""","
				i (+myChildFlag'=0)&&(+$d(^websys.MenuI("SubMenuOf1",mySMRowID))){
					set tmpjsonstr=tmpjsonstr_"""leaf"":false"_","
					i (filter'=""){
						set tmpjsonstr=tmpjsonstr_"""state"""_":"_"""open"""
					}else{
						set tmpjsonstr=tmpjsonstr_"""state"""_":"_"""closed"""
					}
				}else{
					set tmpjsonstr=tmpjsonstr_"""leaf"":true"
				}
				set tmpjsonstr=tmpjsonstr_"}"
				
				continue:(returnShowFlag="")&&(filter'="")&&(myCaption'[filter)
				s:showFlag="" showFlag="Y"
				i myjosnstr="" d
				.s myjosnstr=tmpjsonstr
				e    d
				.s myjosnstr=myjosnstr_","_tmpjsonstr
			}
			
			d myMenuObj.%Close()
		}
		
	}
	
	k myMenuArray
	s myjosnstr="["_myjosnstr_"]"
	q myjosnstr
}

/// 获取菜单是否显示的权限 
/// =0 不显示
/// =1 显示
/// 保存的 选择项的最大RowID值，
ClassMethod GetMenuSecurity(Id As %String) As %String
{
	n (Id,%session)
	s enabled=0
	s myMenuSecurity=$g(%session.Data("LOGON.GROUPMENUS"))
	i myMenuSecurity="" s enabled=0 i 1
	e  i $zbitlen(myMenuSecurity)<Id s enabled=0 i 1
	e  s enabled=$s($zbitget(myMenuSecurity,Id):1,1:0)
	q enabled
}

/// 
/// Descript:	判断登录安全组是否有相应菜单权限
/// Creator:	wxj
/// CreateDate:	2020-11-03
/// Input:		菜单id
/// Return：	0- 无  1-有
ClassMethod GetMenuSecurityByGroup(id As %String, GroupId = "") As %String
{
	n (id,GroupId,%session)
	i (GroupId="")&&$d(%session) d
	.s GroupId=%session.Data("LOGON.GROUPID")
	s myEprGSRowID=$o(^ooGroupSettingsI("GroupDRIndex",GroupId,0))
	q:(myEprGSRowID="") 0
	s ShowFlag=0
	q:+id=0 0
	s myMenuObj=##Class(websys.Menu).%OpenId(id,0)
	q:'$IsObject(myMenuObj) 0
	s ShowFlag=..GetMenuSecurity(id)
	q:+ShowFlag=0 0
	s subMenuObj=myMenuObj.SubMenuOf
	f {
		q:'$IsObject(subMenuObj)
		s subMenuId=subMenuObj.%Id()
		q:(+subMenuId=0)||(subMenuId=1)
		s ShowFlag=..GetMenuSecurity(subMenuId)
		q:+ShowFlag=0
		s subMenuObj = subMenuObj.SubMenuOf
	}
	q:'$IsObject(subMenuObj) 1
	q ShowFlag
}

/// Descript:	判断登录安全组是否有相应菜单权限(传入URL直接判断权限返回NodeInfo）
/// Creator:	ljl
/// CreateDate:	2022-10-13
/// Input:		菜单url
/// Return：	NodeInfo
ClassMethod GetMenuSecurityByUrl(NodeUrl As %String, GroupId = "") As %String
{
	n (NodeUrl,GroupId,%session)
	s NodeInfo=""
	s sqlStr = "select ID as NodeId,Caption as NodeCaption from websys.Menu WHERE LinkUrl='"_NodeUrl_"'"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	If $$$ISERR(sc)  q NodeInfo
	While(result.Next())
	{
		q:NodeInfo'=""
		s NodeId = result.Data("NodeId")
		s NodeCaption = result.Data("NodeCaption")
		s ShowFlag=..GetMenuSecurityByGroup(NodeId,GroupId)
		continue:ShowFlag'=1
		s NodeInfo=NodeId_"^"_NodeCaption_"^"_NodeUrl
	}
	s len=$l(NodeInfo,"^") ;保证引用位置的严谨性
	s:len'=3 NodeInfo=""
	q NodeInfo
}

}

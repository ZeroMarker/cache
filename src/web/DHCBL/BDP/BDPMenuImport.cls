/// 名称:基础数据平台组 菜单、BDP功能大表数据导入导出。不覆盖菜单。 
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2015-6-26
Class web.DHCBL.BDP.BDPMenuImport Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 新： code数据完全相同的跳过，不同的修改，不存在的新增
/// 陈莹 2016-1-13
/// 从D:\文件夹下 导入知识库数据TMPBIKB.gof
/// w ##class(web.DHCBL.BDP.BDPMenuImport).ImportGof("D:\tmp\TMPMENU.gof")   主web
ClassMethod ImportGof(path) As %String
{
	n (path)
	if path'[".gof"   q "请选择正确的gof文件"
	s existflag=##class(%File).Exists(path)
	if existflag=0 q "gof文件不存在"
	
	if (path["\") 
	{
		s filename=$p(path,"\",$l(path,"\"))
	}
		
	if (path["/")
	{
		s filename=$p(path,"/",$l(path,"/"))
	}
	s length=$l(filename)
 	s packagename=$e(path,1,*-length)
 	k ^TMPMENU
	d $SYSTEM.OBJ.ImportDir(packagename, filename)

	k ^MEMUGOF
	k ^User.BDPExecutablesI
	d ##class(User.BDPExecutables).%BuildIndices()
	k ^User.BDPExtExecItemI
	d ##class(User.BDPExtExecItem).%BuildIndices()
	k ^User.BDPMenuI
	d ##class(User.BDPMenu).%BuildIndices()
	s chssflag= ##class(web.DHCBL.BDP.FindTableStructure).ClassExistOrNot("CHSS.DictHospital")
	if (chssflag=1)
	{
		d ##class(CHSS.DictHospital).%BuildIndices()
	}
	s result=0
	//User.BDPExecutables
	s code="",flag=0
	for 
	{
		s code=$o(^TMPMENU("User.BDPExecutables",code)) q:code=""
		s code1= ..trim(code)   ///去掉末尾空格
		
		s flag=$d(^User.BDPExecutablesI("CodeIndex"," "_$zcvt(code1,"U")))
		i (flag=10)
		{
			s id=$o(^User.BDPExecutablesI("CodeIndex"," "_$ZCONVERT(code1,"U"),0))
			if id="" continue
			s oobj=##class(User.BDPExecutables).%OpenId(id)
			////判断是否和原数据一样，一样则不修改	
   			s cstrnew="{list:[{Code:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),4)_""",Caption:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),3)_""",JavaScriptFile:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),6)_""",BDAJavaScriptFile:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),7)_""",Description:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),5)_""",PackageName:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),8)_""",ClassName:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),9)_""",PropertyName:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),10)_"""}]}"
   			s cstrold="{list:[{Code:"""_oobj.Code_""",Caption:"""_oobj.Caption_""",JavaScriptFile:"""_oobj.JavaScriptFile_""",BDAJavaScriptFile:"""_oobj.BDAJavaScriptFile_""",Description:"""_oobj.Description_""",PackageName:"""_oobj.PackageName_""",ClassName:"""_oobj.ClassName_""",PropertyName:"""_oobj.PropertyName_"""}]}"
   			d oobj.%Close()
   			if (cstrnew=cstrold)
   			{
	   			s result=2 ///跳过修改
	   		}
   			else
   			{
	   			///修改
	   			s eobj=##class(web.Entity.BDP.BDPExecutables).%New()
   				s eobj.ID=id
				s JavaScriptFile=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),6)
  				s BDAJavaScriptFile=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),7)
   				s:JavaScriptFile'="" JavaScriptFile=$tr(JavaScriptFile," ","")
   				s:BDAJavaScriptFile'="" BDAJavaScriptFile=$tr(BDAJavaScriptFile," ","")
				s eobj.Code = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),4)
				s eobj.Caption = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),3)
				s eobj.JavaScriptFile =JavaScriptFile
				s eobj.BDAJavaScriptFile =BDAJavaScriptFile
				s eobj.Description = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),5)
				s eobj.ActiveFlag=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),2)
				s:eobj.ActiveFlag="" eobj.ActiveFlag="Y"
				s eobj.PackageName=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),8)
				s eobj.ClassName=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),9) 
				s eobj.PropertyName=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),10)
				s estr=..SaveEntityE(eobj)
				if (estr["success:'true'")
				{
   					s result=1
   				}
				if (estr["success:'false'")
				{
					s result=0
					s ^ERROR("BDP功能大表",$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),4),$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),3))=estr
				}
   			}
   			
   			s parref=id
			//User.BDPExtExecItem
			s childCode = 0,flag1=0
			for
			{
				s childCode = $o(^TMPMENU("User.BDPExtExecItem",code,childCode)) q:childCode=""
				s childCode1= ..trim(childCode)   ///去掉末尾空格
				s flag1=$d(^User.BDPExtExecItemI("CodeIndex"," "_$ZCONVERT(childCode1,"U"),parref))
				i (flag1=10)
				{
					s idd=$o(^User.BDPExtExecItemI("CodeIndex"," "_$zcvt(childCode1,"U"),id,0))
					if idd="" continue
					s BDEFID=id_"||"_idd
					s itemoobj=##class(User.BDPExtExecItem).%OpenId(BDEFID)
					////判断是否和原数据一样，一样则不修改
	
					s cstritemnew="{list:[{BDEFCode:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20)_""",BDEFName:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37)_""",BDEFReadOnly:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),27)_""",BDEFAllowBlank:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),18)_""",BDEFHidden:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),24)_""",BDEFEditable:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),22)_""",BDEFToolTip:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),30)_""",BDEFToolTipType:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),31)_""",BDEFType:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),32)_""",BDEFAutoShow:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),19)_""",BDEFIconCls:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),26)_""",BDEFHandler:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),23)_""",BDEFXType:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),34)_""",BDEFValidator:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),33)_""",BDEFHiddenName:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),25)_""",BDEFRegex:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),28)_""",BDEFRegexText:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),29)_""",BDEFValueGet:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),35)_""",BDEFValueSet:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),36)_"""}]}"
					s cstritemold="{list:[{BDEFCode:"""_itemoobj.Code_""",BDEFName:"""_itemoobj.Name_""",BDEFReadOnly:"""_itemoobj.ReadOnly_""",BDEFAllowBlank:"""_itemoobj.AllowBlank_""",BDEFHidden:"""_itemoobj.Hidden_""",BDEFEditable:"""_itemoobj.Editable_""",BDEFToolTip:"""_itemoobj.ToolTip_""",BDEFToolTipType:"""_itemoobj.ToolTipType_""",BDEFType:"""_itemoobj.Type_""",BDEFAutoShow:"""_itemoobj.AutoShow_""",BDEFIconCls:"""_itemoobj.IconCls_""",BDEFHandler:"""_itemoobj.Handler_""",BDEFXType:"""_itemoobj.XType_""",BDEFValidator:"""_itemoobj.Validator_""",BDEFHiddenName:"""_itemoobj.HiddenName_""",BDEFRegex:"""_itemoobj.Regex_""",BDEFRegexText:"""_itemoobj.RegexText_""",BDEFValueGet:"""_itemoobj.ValueGet_""",BDEFValueGet:"""_itemoobj.ValueGet_"""}]}"
					d itemoobj.%Close()
					if (cstritemnew=cstritemold)
					{
						s result=2 ///数据相同，跳过
					
					}	
					else
					{
						//数据不同，修改
						s eobj1=##class(web.Entity.BDP.BDPExtExecItem).%New()
						s eobj1.BDEFRowId=BDEFID
						s eobj1.BDEFBDETParRef=parref
						s eobj1.BDEFCode = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20)
						s eobj1.BDEFName = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37)
						s eobj1.BDEFCode =..trim(eobj1.BDEFCode)
						s eobj1.BDEFName =..trim(eobj1.BDEFName)
						s eobj1.BDEFReadOnly = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),27)
						s eobj1.BDEFAllowBlank = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),18)
						s eobj1.BDEFHidden =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),24)
						s eobj1.BDEFEditable = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),22)
						s eobj1.BDEFToolTip =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),30)
						s eobj1.BDEFToolTipType = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),31)
						s eobj1.BDEFType =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),32)
						s eobj1.BDEFAutoShow = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),19)
						s eobj1.BDEFIconCls =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),26)
						s eobj1.BDEFHandler = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),23)
						s eobj1.BDEFXType = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),34)
						s eobj1.BDEFValidator = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),33)
						s eobj1.BDEFHiddenName = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),25)
						s eobj1.BDEFRegex =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),28)
						s eobj1.BDEFRegexText = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),29)
						s eobj1.BDEFValueGet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),35)
						s eobj1.BDEFValueSet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),36)
						s estr1=..SaveEntityI(eobj1)
						if (estr1["success:'true'")
						{
							 s result=1
							
						}
						if (estr1["success:'false'")
						{
							s result=0
						
							s ^ERROR("功能元素",code,$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20),$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37))=estr1
						}
					}
				}
				else
				{
					///新增功能元素
					s eobj1=##class(web.Entity.BDP.BDPExtExecItem).%New()
					s eobj1.BDEFRowId=""
					s eobj1.BDEFBDETParRef=parref
					s eobj1.BDEFCode = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20)
					s eobj1.BDEFName = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37)
					s eobj1.BDEFCode =..trim(eobj1.BDEFCode)
					s eobj1.BDEFName =..trim(eobj1.BDEFName)
					s eobj1.BDEFReadOnly = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),27)
					s eobj1.BDEFAllowBlank = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),18)
					s eobj1.BDEFHidden =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),24)
					s eobj1.BDEFEditable = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),22)
					s eobj1.BDEFToolTip =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),30)
					s eobj1.BDEFToolTipType = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),31)
					s eobj1.BDEFType =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),32)
					s eobj1.BDEFAutoShow = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),19)
					s eobj1.BDEFIconCls =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),26)
					s eobj1.BDEFHandler = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),23)
					s eobj1.BDEFXType = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),34)
					s eobj1.BDEFValidator = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),33)
					s eobj1.BDEFHiddenName = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),25)
					s eobj1.BDEFRegex =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),28)
					s eobj1.BDEFRegexText = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),29)
					s eobj1.BDEFValueGet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),35)
					s eobj1.BDEFValueSet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),36)
					s estr1=..SaveEntityI(eobj1)
					if (estr1["success:'true'")
					{
						 s result=1
					}
					if (estr1["success:'false'")
					{
						s result=0
						s ^ERROR("功能元素",code,$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20),$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37))=estr1
					}
				}
			}
		}
		else
		{
			///新增功能大表
  			s JavaScriptFile=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),6)
  			s BDAJavaScriptFile=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),7)
   			s:JavaScriptFile'="" JavaScriptFile=$tr(JavaScriptFile," ","")
   			s:BDAJavaScriptFile'="" BDAJavaScriptFile=$tr(BDAJavaScriptFile," ","")
   			s eobj=##class(web.Entity.BDP.BDPExecutables).%New()
			s eobj.ID=""
			s eobj.Code = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),4)
			s eobj.Caption = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),3)
			s eobj.JavaScriptFile =JavaScriptFile
			s eobj.BDAJavaScriptFile =BDAJavaScriptFile
			s eobj.Description = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),5)
			s eobj.ActiveFlag=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),2)
			s:eobj.ActiveFlag="" eobj.ActiveFlag="Y"
			s eobj.PackageName=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),8)
			s eobj.ClassName=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),9) 
			s eobj.PropertyName=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),10)
			s estr=..SaveEntityE(eobj)
			if (estr["success:'true'")
			{
   				s result=1
   				s parref=$p($p(estr,"id:'",2),"'",1)
   				//User.BDPExtExecItem
				s childCode = 0,flag1=0
				for 
				{
					s childCode = $o(^TMPMENU("User.BDPExtExecItem",code,childCode)) q:childCode=""
					s childCode1= ..trim(childCode)   ///去掉末尾空格
					s flag1=$d(^User.BDPExtExecItemI("CodeIndex"," "_$ZCONVERT(childCode1,"U"),parref))
					i (flag1=10)
					{
						 s result=0
					}
					else
					{
					
   						s eobj1=##class(web.Entity.BDP.BDPExtExecItem).%New()
						s eobj1.BDEFRowId=""
						s eobj1.BDEFBDETParRef=parref
						s eobj1.BDEFCode = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20)
						s eobj1.BDEFName = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37)
						s eobj1.BDEFCode =..trim(eobj1.BDEFCode)
   						s eobj1.BDEFName =..trim(eobj1.BDEFName)
						s eobj1.BDEFReadOnly = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),27)
						s eobj1.BDEFAllowBlank = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),18)
						s eobj1.BDEFHidden =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),24)
						s eobj1.BDEFEditable = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),22)
						s eobj1.BDEFToolTip =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),30)
						s eobj1.BDEFToolTipType = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),31)
						s eobj1.BDEFType =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),32)
						s eobj1.BDEFAutoShow = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),19)
  						s eobj1.BDEFIconCls =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),26)
   						s eobj1.BDEFHandler = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),23)
   						s eobj1.BDEFXType = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),34)
   						s eobj1.BDEFValidator = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),33)
   						s eobj1.BDEFHiddenName = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),25)
   						s eobj1.BDEFRegex =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),28)
   						s eobj1.BDEFRegexText = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),29)
   						s eobj1.BDEFValueGet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),35)
   						s eobj1.BDEFValueSet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),36)
   						s estr1=..SaveEntityI(eobj1)
   						if (estr1["success:'true'")
   						{
	   						 s result=1
	   					}
						if (estr1["success:'false'")
						{
							s result=0
							s ^ERROR("功能元素",code,$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20),$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37))=estr1
						}
					}
				}
   				
			}
			if (estr["success:'false'")
			{
				s result=0
				s ^ERROR("BDP功能大表",$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),4),$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),3))=estr
			}
			
		}
	}
	
	s code="",n=1,flag2=0
	//User.BDPMenu
	for {
		s code=$o(^TMPMENU("User.BDPMenu",n,0)) q:code=""
		s m=n
		s n=n+1
		s code1= ..trim(code)   ///去掉末尾空格
		s flag2=$d(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(code1,"U")))
		i (flag2=10)
		{
			s menuid=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(code1,"U"),0))
			if menuid="" continue
			s menuoobj=##class(User.BDPMenu).%OpenId(menuid)
			
   			s LinkFuntionDR=$o(^TMPMENU("User.BDPMenu",m,code,0))
   			s LinkFuntionDR1=..trim(LinkFuntionDR)   ///INCSYSCOUNTER 
			s:LinkFuntionDR1'="" LinkFuntionDRID=$o(^User.BDPExecutablesI("CodeIndex"," "_$ZCONVERT(LinkFuntionDR1,"U"),0))
			s:LinkFuntionDR1="" LinkFuntionDRID="",LinkFuntionDR=0
			s ParentMenuDr=$o(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,0))
			s ParentMenuDr1= ..trim(ParentMenuDr)
			s:ParentMenuDr1'="" ParentMenuDrID=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$ZCONVERT(ParentMenuDr1,"U"),0))
			s:ParentMenuDr1="" ParentMenuDrID="",ParentMenuDr=0
			//////有些是先建子菜单，再建父菜单，再把子菜单指向父菜单的，要等保存完所有菜单后再处理这些
			if ((ParentMenuDr'="")&(ParentMenuDr'=0)&(ParentMenuDrID="")) s ^MEMUGOF(ParentMenuDr,code)=""
			s ProductLineDrCode=$G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr,"PLineDr"))
   			s:ProductLineDrCode'="" ProductLineDrID=$o(^User.DHCProductLineI("CodeIndex"," "_$zcvt(ProductLineDrCode,"U"),0))
   			s:ProductLineDrCode="" ProductLineDrID=""

			////↓如果是menuoobj.dr =4@User.BDPMenu 与实际的91值不同
			s strold="{list:[{Caption:'"_menuoobj.Caption_"',Code:'"_menuoobj.Code_"',CompName:'"_menuoobj.CompName_"',Image:'"_menuoobj.Image_"',LinkFuntionDR:'"_$LISTGET($G(^User.BDPMenuD(menuid)),4)_"',LinkUrl:'"_menuoobj.LinkUrl_"',Method:'"_menuoobj.Method_"',ParentMenuDr:'"_$LISTGET($G(^User.BDPMenuD(menuid)),11)_"',ProductLineDr:'"_$LISTGET($G(^User.BDPMenuD(menuid)),18)_"',Sequence:'"_menuoobj.Sequence_"',ShortcutKey:'"_menuoobj.ShortcutKey_"',ShowInNewWindow:'"_menuoobj.ShowInNewWindow_"',ValueExpression:'"_menuoobj.ValueExpression_"',ActiveFlag:'"_menuoobj.ActiveFlag_"'}]}"
			
			s strnew="{list:[{Caption:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),3)_"',Code:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),2)_"',CompName:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),17)_"',Image:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),6)_"',LinkFuntionDR:'"_LinkFuntionDRID_"',LinkUrl:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),5)_"',Method:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),7)_"',ParentMenuDr:'"_ParentMenuDrID_"',ProductLineDr:'"_ProductLineDrID_"',Sequence:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),8)_"',ShortcutKey:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),9)_"',ShowInNewWindow:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),10)_"',ValueExpression:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),15)_"',ActiveFlag:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),16)_"'}]}"
			if (strold=strnew)
			{
				s result=2 ///数据相同，跳过
			}	
			else
			{
				s eobj2=##class(web.Entity.BDP.BDPMenuDefine).%New()
				s eobj2.ID = menuid
				s eobj2.Code = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),2)
   				s eobj2.Caption = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),3)
   				s eobj2.LinkFuntionDR=LinkFuntionDRID
   				s eobj2.LinkUrl = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),5)
   				s eobj2.Image = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),6)
  				s eobj2.Method =$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),7)
  				s eobj2.Sequence = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),8)
  				s eobj2.ShortcutKey = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),9)
  				s eobj2.ShowInNewWindow =$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),10)
  				s eobj2.ParentMenuDr=ParentMenuDrID
  				s eobj2.UpdateDate = +$p($h,",",1)
  				s eobj2.UpdateTime = +$p($h,",",2)
   				//s eobj2.UpdateUser=$Get(%session.Data("LOGON.USERID"))
   				s eobj2.ValueExpression = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),15)
   				s eobj2.ActiveFlag = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),16)
   				s eobj2.actMenuBDP= $p(eobj2.ActiveFlag,"^",1)
   				s eobj2.actMenuAutItem= $p(eobj2.ActiveFlag,"^",2)
   				s eobj2.actMenuAutData= $p(eobj2.ActiveFlag,"^",3)
   				s eobj2.CompName=$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),17)
   				s eobj2.ProductLineDr=ProductLineDrID
   				s estr2=..SaveEntityM(eobj2)
   				if (estr2["success:'true'")
				{
   					 s result=1
   				}
				if (estr2["success:'false'")
				{
					s result=0
					s ^ERROR("菜单",$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),2),$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),3))=estr2
				}
			}	
		}
		else
		{
			s LinkFuntionDR=$o(^TMPMENU("User.BDPMenu",m,code,0))
   			s LinkFuntionDR1=..trim(LinkFuntionDR)   ///INCSYSCOUNTER 
			s:LinkFuntionDR1'="" LinkFuntionDRID=$o(^User.BDPExecutablesI("CodeIndex"," "_$ZCONVERT(LinkFuntionDR1,"U"),0))
			s:LinkFuntionDR1="" LinkFuntionDRID="",LinkFuntionDR=0
			s ParentMenuDr=$o(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,0))
			s ParentMenuDr1= ..trim(ParentMenuDr)
			s:ParentMenuDr'="" ParentMenuDrID=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$ZCONVERT(ParentMenuDr1,"U"),0))
			s:ParentMenuDr="" ParentMenuDrID="",ParentMenuDr=0
			//////有些是先建子菜单，再建父菜单，再把子菜单指向父菜单的，要等保存完所有菜单后再处理这些
			if ((ParentMenuDr'="")&(ParentMenuDr'=0)&(ParentMenuDrID="")) s ^MEMUGOF(ParentMenuDr,code)=""
			s ProductLineDrCode=$G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr,"PLineDr"))
   			s:ProductLineDrCode'="" ProductLineDrID=$o(^User.DHCProductLineI("CodeIndex"," "_$zcvt(ProductLineDrCode,"U"),0))
   			s:ProductLineDrCode="" ProductLineDrID=""
   				
			s eobj2=##class(web.Entity.BDP.BDPMenuDefine).%New()
			s eobj2.ID = ""
			s eobj2.Code = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),2)
			s eobj2.Caption = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),3)
			s eobj2.LinkFuntionDR=LinkFuntionDRID
			s eobj2.LinkUrl = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),5)
			s eobj2.Image = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),6)
			s eobj2.Method =$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),7)
			s eobj2.Sequence = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),8)
			s eobj2.ShortcutKey = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),9)
			s eobj2.ShowInNewWindow =$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),10)
			s eobj2.ParentMenuDr=ParentMenuDrID
			s eobj2.UpdateDate = +$p($h,",",1)
			s eobj2.UpdateTime = +$p($h,",",2)
			//s eobj2.UpdateUser=$Get(%session.Data("LOGON.USERID"))
			s eobj2.ValueExpression = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),15)
			s eobj2.ActiveFlag = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),16)
			s eobj2.actMenuBDP= $p(eobj2.ActiveFlag,"^",1)
			s eobj2.actMenuAutItem= $p(eobj2.ActiveFlag,"^",2)
			s eobj2.actMenuAutData= $p(eobj2.ActiveFlag,"^",3)
			s eobj2.CompName=$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),17)
			s eobj2.ProductLineDr=ProductLineDrID
			s estr2=..SaveEntityM(eobj2)
			if (estr2["success:'true'")
			{
				 s result=1
			}
			if (estr2["success:'false'")
			{
				s result=0
				s ^ERROR("菜单",$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),2),$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),3))=estr2
			}
		}
	}
	
	
	s parcode=""
	for
	{		
		s parcode=$o(^MEMUGOF(parcode)) q:parcode=""
		s parcode1=..trim(parcode)
		s parid= $o(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(parcode1,"U"),0))
		continue:parid=""
		s childcode=0
		for 
		{
			s childcode=$o(^MEMUGOF(parcode,childcode)) q:childcode=""
			S childcode1=..trim(childcode)  ////code末尾为多个空格，但是保存后的索引里末尾不带空格，开头可以带空格
			s childid=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(childcode1,"U"),0))
			Q:childid=""
			s oobj=##class(User.BDPMenu).%OpenId(childid)
			d oobj.ParentMenuDrSetObjectId(parid)
  			s oobj.UpdateDate = +$p($h,",",1)
			s oobj.UpdateTime = +$p($h,",",2)
			//d oobj.UpdateUserSetObjectId($g(%session.Data("LOGON.USERID")))
			///S oobj.UpdateUser="1"
			ts
			s sc=oobj.%Save()
			d oobj.%Close()	
			If $$$ISOK(sc)
			{	
				Tcommit
				K ^MEMUGOF(parcode,childcode)
			}
			else
			{
				Trollback
				S ^ERROR("菜单1",childcode)=parcode
			}
		}
	}
	
	k ^User.BDPExecutablesI
	d ##class(User.BDPExecutables).%BuildIndices()
	k ^User.BDPExtExecItemI
	d ##class(User.BDPExtExecItem).%BuildIndices()
	k ^User.BDPMenuI
	d ##class(User.BDPMenu).%BuildIndices()
	
	q "导入完成"
}

/// w ##class(web.DHCBL.BDP.BDPMenuImport).ImportGof1()
ClassMethod ImportGof1() As %String
{
	k ^MEMUGOF
	k ^User.BDPExecutablesI
	d ##class(User.BDPExecutables).%BuildIndices()
	k ^User.BDPExtExecItemI
	d ##class(User.BDPExtExecItem).%BuildIndices()
	k ^User.BDPMenuI
	d ##class(User.BDPMenu).%BuildIndices()
	s chssflag= ##class(web.DHCBL.BDP.FindTableStructure).ClassExistOrNot("CHSS.DictHospital")
	if (chssflag=1)
	{
		d ##class(CHSS.DictHospital).%BuildIndices()
	}
	s result=0
	//User.BDPExecutables
	s code="",flag=0
	for 
	{
		s code=$o(^TMPMENU("User.BDPExecutables",code)) q:code=""
		s code1= ..trim(code)   ///去掉末尾空格
		
		s flag=$d(^User.BDPExecutablesI("CodeIndex"," "_$zcvt(code1,"U")))
		i (flag=10)
		{
			s id=$o(^User.BDPExecutablesI("CodeIndex"," "_$ZCONVERT(code1,"U"),0))
			if id="" continue
			s oobj=##class(User.BDPExecutables).%OpenId(id)
			////判断是否和原数据一样，一样则不修改	
   			s cstrnew="{list:[{Code:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),4)_""",Caption:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),3)_""",JavaScriptFile:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),6)_""",BDAJavaScriptFile:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),7)_""",Description:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),5)_""",PackageName:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),8)_""",ClassName:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),9)_""",PropertyName:"""_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),10)_"""}]}"
   			s cstrold="{list:[{Code:"""_oobj.Code_""",Caption:"""_oobj.Caption_""",JavaScriptFile:"""_oobj.JavaScriptFile_""",BDAJavaScriptFile:"""_oobj.BDAJavaScriptFile_""",Description:"""_oobj.Description_""",PackageName:"""_oobj.PackageName_""",ClassName:"""_oobj.ClassName_""",PropertyName:"""_oobj.PropertyName_"""}]}"
   			d oobj.%Close()
   			if (cstrnew=cstrold)
   			{
	   			s result=2 ///跳过修改
	   		}
   			else
   			{
	   			///修改
	   			s eobj=##class(web.Entity.BDP.BDPExecutables).%New()
   				s eobj.ID=id
				s JavaScriptFile=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),6)
  				s BDAJavaScriptFile=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),7)
   				s:JavaScriptFile'="" JavaScriptFile=$tr(JavaScriptFile," ","")
   				s:BDAJavaScriptFile'="" BDAJavaScriptFile=$tr(BDAJavaScriptFile," ","")
				s eobj.Code = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),4)
				s eobj.Caption = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),3)
				s eobj.JavaScriptFile =JavaScriptFile
				s eobj.BDAJavaScriptFile =BDAJavaScriptFile
				s eobj.Description = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),5)
				s eobj.ActiveFlag=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),2)
				s:eobj.ActiveFlag="" eobj.ActiveFlag="Y"
				s eobj.PackageName=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),8)
				s eobj.ClassName=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),9) 
				s eobj.PropertyName=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),10)
				s estr=..SaveEntityE(eobj)
				if (estr["success:'true'")
				{
   					s result=1
   				}
				if (estr["success:'false'")
				{
					s result=0
					s ^ERROR("BDP功能大表",$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),4),$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),3))=estr
				}
   			}
   			
   			s parref=id
			//User.BDPExtExecItem
			s childCode = 0,flag1=0
			for
			{
				s childCode = $o(^TMPMENU("User.BDPExtExecItem",code,childCode)) q:childCode=""
				s childCode1= ..trim(childCode)   ///去掉末尾空格
				s flag1=$d(^User.BDPExtExecItemI("CodeIndex"," "_$ZCONVERT(childCode1,"U"),parref))
				i (flag1=10)
				{
					s idd=$o(^User.BDPExtExecItemI("CodeIndex"," "_$zcvt(childCode1,"U"),id,0))
					if idd="" continue
					s BDEFID=id_"||"_idd
					s itemoobj=##class(User.BDPExtExecItem).%OpenId(BDEFID)
					////判断是否和原数据一样，一样则不修改
	
					s cstritemnew="{list:[{BDEFCode:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20)_""",BDEFName:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37)_""",BDEFReadOnly:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),27)_""",BDEFAllowBlank:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),18)_""",BDEFHidden:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),24)_""",BDEFEditable:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),22)_""",BDEFToolTip:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),30)_""",BDEFToolTipType:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),31)_""",BDEFType:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),32)_""",BDEFAutoShow:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),19)_""",BDEFIconCls:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),26)_""",BDEFHandler:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),23)_""",BDEFXType:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),34)_""",BDEFValidator:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),33)_""",BDEFHiddenName:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),25)_""",BDEFRegex:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),28)_""",BDEFRegexText:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),29)_""",BDEFValueGet:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),35)_""",BDEFValueSet:"""_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),36)_"""}]}"
					s cstritemold="{list:[{BDEFCode:"""_itemoobj.Code_""",BDEFName:"""_itemoobj.Name_""",BDEFReadOnly:"""_itemoobj.ReadOnly_""",BDEFAllowBlank:"""_itemoobj.AllowBlank_""",BDEFHidden:"""_itemoobj.Hidden_""",BDEFEditable:"""_itemoobj.Editable_""",BDEFToolTip:"""_itemoobj.ToolTip_""",BDEFToolTipType:"""_itemoobj.ToolTipType_""",BDEFType:"""_itemoobj.Type_""",BDEFAutoShow:"""_itemoobj.AutoShow_""",BDEFIconCls:"""_itemoobj.IconCls_""",BDEFHandler:"""_itemoobj.Handler_""",BDEFXType:"""_itemoobj.XType_""",BDEFValidator:"""_itemoobj.Validator_""",BDEFHiddenName:"""_itemoobj.HiddenName_""",BDEFRegex:"""_itemoobj.Regex_""",BDEFRegexText:"""_itemoobj.RegexText_""",BDEFValueGet:"""_itemoobj.ValueGet_""",BDEFValueGet:"""_itemoobj.ValueGet_"""}]}"
					d itemoobj.%Close()
					if (cstritemnew=cstritemold)
					{
						s result=2 ///数据相同，跳过
					
					}	
					else
					{
						//数据不同，修改
						s eobj1=##class(web.Entity.BDP.BDPExtExecItem).%New()
						s eobj1.BDEFRowId=BDEFID
						s eobj1.BDEFBDETParRef=parref
						s eobj1.BDEFCode = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20)
						s eobj1.BDEFName = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37)
						s eobj1.BDEFCode =..trim(eobj1.BDEFCode)
						s eobj1.BDEFName =..trim(eobj1.BDEFName)
						s eobj1.BDEFReadOnly = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),27)
						s eobj1.BDEFAllowBlank = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),18)
						s eobj1.BDEFHidden =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),24)
						s eobj1.BDEFEditable = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),22)
						s eobj1.BDEFToolTip =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),30)
						s eobj1.BDEFToolTipType = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),31)
						s eobj1.BDEFType =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),32)
						s eobj1.BDEFAutoShow = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),19)
						s eobj1.BDEFIconCls =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),26)
						s eobj1.BDEFHandler = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),23)
						s eobj1.BDEFXType = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),34)
						s eobj1.BDEFValidator = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),33)
						s eobj1.BDEFHiddenName = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),25)
						s eobj1.BDEFRegex =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),28)
						s eobj1.BDEFRegexText = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),29)
						s eobj1.BDEFValueGet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),35)
						s eobj1.BDEFValueSet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),36)
						s estr1=..SaveEntityI(eobj1)
						if (estr1["success:'true'")
						{
							 s result=1
							
						}
						if (estr1["success:'false'")
						{
							s result=0
						
							s ^ERROR("功能元素",code,$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20),$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37))=estr1
						}
					}
				}
				else
				{
					///新增功能元素
					s eobj1=##class(web.Entity.BDP.BDPExtExecItem).%New()
					s eobj1.BDEFRowId=""
					s eobj1.BDEFBDETParRef=parref
					s eobj1.BDEFCode = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20)
					s eobj1.BDEFName = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37)
					s eobj1.BDEFCode =..trim(eobj1.BDEFCode)
					s eobj1.BDEFName =..trim(eobj1.BDEFName)
					s eobj1.BDEFReadOnly = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),27)
					s eobj1.BDEFAllowBlank = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),18)
					s eobj1.BDEFHidden =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),24)
					s eobj1.BDEFEditable = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),22)
					s eobj1.BDEFToolTip =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),30)
					s eobj1.BDEFToolTipType = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),31)
					s eobj1.BDEFType =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),32)
					s eobj1.BDEFAutoShow = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),19)
					s eobj1.BDEFIconCls =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),26)
					s eobj1.BDEFHandler = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),23)
					s eobj1.BDEFXType = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),34)
					s eobj1.BDEFValidator = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),33)
					s eobj1.BDEFHiddenName = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),25)
					s eobj1.BDEFRegex =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),28)
					s eobj1.BDEFRegexText = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),29)
					s eobj1.BDEFValueGet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),35)
					s eobj1.BDEFValueSet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),36)
					s estr1=..SaveEntityI(eobj1)
					if (estr1["success:'true'")
					{
						 s result=1
					}
					if (estr1["success:'false'")
					{
						s result=0
						s ^ERROR("功能元素",code,$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20),$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37))=estr1
					}
				}
			}
		}
		else
		{
			///新增功能大表
  			s JavaScriptFile=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),6)
  			s BDAJavaScriptFile=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),7)
   			s:JavaScriptFile'="" JavaScriptFile=$tr(JavaScriptFile," ","")
   			s:BDAJavaScriptFile'="" BDAJavaScriptFile=$tr(BDAJavaScriptFile," ","")
   			s eobj=##class(web.Entity.BDP.BDPExecutables).%New()
			s eobj.ID=""
			s eobj.Code = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),4)
			s eobj.Caption = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),3)
			s eobj.JavaScriptFile =JavaScriptFile
			s eobj.BDAJavaScriptFile =BDAJavaScriptFile
			s eobj.Description = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),5)
			s eobj.ActiveFlag=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),2)
			s:eobj.ActiveFlag="" eobj.ActiveFlag="Y"
			s eobj.PackageName=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),8)
			s eobj.ClassName=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),9) 
			s eobj.PropertyName=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),10)
			s estr=..SaveEntityE(eobj)
			if (estr["success:'true'")
			{
   				s result=1
   				s parref=$p($p(estr,"id:'",2),"'",1)
   				//User.BDPExtExecItem
				s childCode = 0,flag1=0
				for 
				{
					s childCode = $o(^TMPMENU("User.BDPExtExecItem",code,childCode)) q:childCode=""
					s childCode1= ..trim(childCode)   ///去掉末尾空格
					s flag1=$d(^User.BDPExtExecItemI("CodeIndex"," "_$ZCONVERT(childCode1,"U"),parref))
					i (flag1=10)
					{
						 s result=0
					}
					else
					{
					
   						s eobj1=##class(web.Entity.BDP.BDPExtExecItem).%New()
						s eobj1.BDEFRowId=""
						s eobj1.BDEFBDETParRef=parref
						s eobj1.BDEFCode = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20)
						s eobj1.BDEFName = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37)
						s eobj1.BDEFCode =..trim(eobj1.BDEFCode)
   						s eobj1.BDEFName =..trim(eobj1.BDEFName)
						s eobj1.BDEFReadOnly = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),27)
						s eobj1.BDEFAllowBlank = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),18)
						s eobj1.BDEFHidden =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),24)
						s eobj1.BDEFEditable = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),22)
						s eobj1.BDEFToolTip =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),30)
						s eobj1.BDEFToolTipType = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),31)
						s eobj1.BDEFType =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),32)
						s eobj1.BDEFAutoShow = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),19)
  						s eobj1.BDEFIconCls =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),26)
   						s eobj1.BDEFHandler = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),23)
   						s eobj1.BDEFXType = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),34)
   						s eobj1.BDEFValidator = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),33)
   						s eobj1.BDEFHiddenName = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),25)
   						s eobj1.BDEFRegex =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),28)
   						s eobj1.BDEFRegexText = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),29)
   						s eobj1.BDEFValueGet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),35)
   						s eobj1.BDEFValueSet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),36)
   						s estr1=..SaveEntityI(eobj1)
   						if (estr1["success:'true'")
   						{
	   						 s result=1
	   					}
						if (estr1["success:'false'")
						{
							s result=0
							s ^ERROR("功能元素",code,$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20),$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37))=estr1
						}
					}
				}
   				
			}
			if (estr["success:'false'")
			{
				s result=0
				s ^ERROR("BDP功能大表",$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),4),$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),3))=estr
			}
			
		}
	}
	
	s code="",n=1,flag2=0
	//User.BDPMenu
	for {
		s code=$o(^TMPMENU("User.BDPMenu",n,0)) q:code=""
		s m=n
		s n=n+1
		s code1= ..trim(code)   ///去掉末尾空格
		s flag2=$d(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(code1,"U")))
		i (flag2=10)
		{
			s menuid=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(code1,"U"),0))
			if menuid="" continue
			s menuoobj=##class(User.BDPMenu).%OpenId(menuid)
			
   			s LinkFuntionDR=$o(^TMPMENU("User.BDPMenu",m,code,0))
   			s LinkFuntionDR1=..trim(LinkFuntionDR)   ///INCSYSCOUNTER 
			s:LinkFuntionDR1'="" LinkFuntionDRID=$o(^User.BDPExecutablesI("CodeIndex"," "_$ZCONVERT(LinkFuntionDR1,"U"),0))
			s:LinkFuntionDR1="" LinkFuntionDRID="",LinkFuntionDR=0
			s ParentMenuDr=$o(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,0))
			s ParentMenuDr1= ..trim(ParentMenuDr)
			s:ParentMenuDr1'="" ParentMenuDrID=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$ZCONVERT(ParentMenuDr1,"U"),0))
			s:ParentMenuDr1="" ParentMenuDrID="",ParentMenuDr=0
			//////有些是先建子菜单，再建父菜单，再把子菜单指向父菜单的，要等保存完所有菜单后再处理这些
			if ((ParentMenuDr'="")&(ParentMenuDr'=0)&(ParentMenuDrID="")) s ^MEMUGOF(ParentMenuDr,code)=""
			s ProductLineDrCode=$G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr,"PLineDr"))
   			s:ProductLineDrCode'="" ProductLineDrID=$o(^User.DHCProductLineI("CodeIndex"," "_$zcvt(ProductLineDrCode,"U"),0))
   			s:ProductLineDrCode="" ProductLineDrID=""

			////↓如果是menuoobj.dr =4@User.BDPMenu 与实际的91值不同
			s strold="{list:[{Caption:'"_menuoobj.Caption_"',Code:'"_menuoobj.Code_"',CompName:'"_menuoobj.CompName_"',Image:'"_menuoobj.Image_"',LinkFuntionDR:'"_$LISTGET($G(^User.BDPMenuD(menuid)),4)_"',LinkUrl:'"_menuoobj.LinkUrl_"',Method:'"_menuoobj.Method_"',ParentMenuDr:'"_$LISTGET($G(^User.BDPMenuD(menuid)),11)_"',ProductLineDr:'"_$LISTGET($G(^User.BDPMenuD(menuid)),18)_"',Sequence:'"_menuoobj.Sequence_"',ShortcutKey:'"_menuoobj.ShortcutKey_"',ShowInNewWindow:'"_menuoobj.ShowInNewWindow_"',ValueExpression:'"_menuoobj.ValueExpression_"',ActiveFlag:'"_menuoobj.ActiveFlag_"'}]}"
			
			s strnew="{list:[{Caption:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),3)_"',Code:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),2)_"',CompName:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),17)_"',Image:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),6)_"',LinkFuntionDR:'"_LinkFuntionDRID_"',LinkUrl:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),5)_"',Method:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),7)_"',ParentMenuDr:'"_ParentMenuDrID_"',ProductLineDr:'"_ProductLineDrID_"',Sequence:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),8)_"',ShortcutKey:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),9)_"',ShowInNewWindow:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),10)_"',ValueExpression:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),15)_"',ActiveFlag:'"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),16)_"'}]}"
			if (strold=strnew)
			{
				s result=2 ///数据相同，跳过
			}	
			else
			{
				s eobj2=##class(web.Entity.BDP.BDPMenuDefine).%New()
				s eobj2.ID = menuid
				s eobj2.Code = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),2)
   				s eobj2.Caption = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),3)
   				s eobj2.LinkFuntionDR=LinkFuntionDRID
   				s eobj2.LinkUrl = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),5)
   				s eobj2.Image = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),6)
  				s eobj2.Method =$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),7)
  				s eobj2.Sequence = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),8)
  				s eobj2.ShortcutKey = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),9)
  				s eobj2.ShowInNewWindow =$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),10)
  				s eobj2.ParentMenuDr=ParentMenuDrID
  				s eobj2.UpdateDate = +$p($h,",",1)
  				s eobj2.UpdateTime = +$p($h,",",2)
   				//s eobj2.UpdateUser=$Get(%session.Data("LOGON.USERID"))
   				s eobj2.ValueExpression = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),15)
   				s eobj2.ActiveFlag = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),16)
   				s eobj2.actMenuBDP= $p(eobj2.ActiveFlag,"^",1)
   				s eobj2.actMenuAutItem= $p(eobj2.ActiveFlag,"^",2)
   				s eobj2.actMenuAutData= $p(eobj2.ActiveFlag,"^",3)
   				s eobj2.CompName=$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),17)
   				s eobj2.ProductLineDr=ProductLineDrID
   				s estr2=..SaveEntityM(eobj2)
   				if (estr2["success:'true'")
				{
   					 s result=1
   				}
				if (estr2["success:'false'")
				{
					s result=0
					s ^ERROR("菜单",$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),2),$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),3))=estr2
				}
			}	
		}
		else
		{
			s LinkFuntionDR=$o(^TMPMENU("User.BDPMenu",m,code,0))
   			s LinkFuntionDR1=..trim(LinkFuntionDR)   ///INCSYSCOUNTER 
			s:LinkFuntionDR1'="" LinkFuntionDRID=$o(^User.BDPExecutablesI("CodeIndex"," "_$ZCONVERT(LinkFuntionDR1,"U"),0))
			s:LinkFuntionDR1="" LinkFuntionDRID="",LinkFuntionDR=0
			s ParentMenuDr=$o(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,0))
			s ParentMenuDr1= ..trim(ParentMenuDr)
			s:ParentMenuDr'="" ParentMenuDrID=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$ZCONVERT(ParentMenuDr1,"U"),0))
			s:ParentMenuDr="" ParentMenuDrID="",ParentMenuDr=0
			//////有些是先建子菜单，再建父菜单，再把子菜单指向父菜单的，要等保存完所有菜单后再处理这些
			if ((ParentMenuDr'="")&(ParentMenuDr'=0)&(ParentMenuDrID="")) s ^MEMUGOF(ParentMenuDr,code)=""
			s ProductLineDrCode=$G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr,"PLineDr"))
   			s:ProductLineDrCode'="" ProductLineDrID=$o(^User.DHCProductLineI("CodeIndex"," "_$zcvt(ProductLineDrCode,"U"),0))
   			s:ProductLineDrCode="" ProductLineDrID=""
   				
			s eobj2=##class(web.Entity.BDP.BDPMenuDefine).%New()
			s eobj2.ID = ""
			s eobj2.Code = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),2)
			s eobj2.Caption = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),3)
			s eobj2.LinkFuntionDR=LinkFuntionDRID
			s eobj2.LinkUrl = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),5)
			s eobj2.Image = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),6)
			s eobj2.Method =$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),7)
			s eobj2.Sequence = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),8)
			s eobj2.ShortcutKey = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),9)
			s eobj2.ShowInNewWindow =$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),10)
			s eobj2.ParentMenuDr=ParentMenuDrID
			s eobj2.UpdateDate = +$p($h,",",1)
			s eobj2.UpdateTime = +$p($h,",",2)
			//s eobj2.UpdateUser=$Get(%session.Data("LOGON.USERID"))
			s eobj2.ValueExpression = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),15)
			s eobj2.ActiveFlag = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),16)
			s eobj2.actMenuBDP= $p(eobj2.ActiveFlag,"^",1)
			s eobj2.actMenuAutItem= $p(eobj2.ActiveFlag,"^",2)
			s eobj2.actMenuAutData= $p(eobj2.ActiveFlag,"^",3)
			s eobj2.CompName=$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),17)
			s eobj2.ProductLineDr=ProductLineDrID
			s estr2=..SaveEntityM(eobj2)
			if (estr2["success:'true'")
			{
				 s result=1
			}
			if (estr2["success:'false'")
			{
				s result=0
				s ^ERROR("菜单",$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),2),$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),3))=estr2
			}
		}
	}
	
	
	s parcode=""
	for
	{		
		s parcode=$o(^MEMUGOF(parcode)) q:parcode=""
		s parcode1=..trim(parcode)
		s parid= $o(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(parcode1,"U"),0))
		continue:parid=""
		s childcode=0
		for 
		{
			s childcode=$o(^MEMUGOF(parcode,childcode)) q:childcode=""
			S childcode1=..trim(childcode)  ////code末尾为多个空格，但是保存后的索引里末尾不带空格，开头可以带空格
			s childid=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(childcode1,"U"),0))
			Q:childid=""
			s oobj=##class(User.BDPMenu).%OpenId(childid)
			d oobj.ParentMenuDrSetObjectId(parid)
  			s oobj.UpdateDate = +$p($h,",",1)
			s oobj.UpdateTime = +$p($h,",",2)
			//d oobj.UpdateUserSetObjectId($g(%session.Data("LOGON.USERID")))
			///S oobj.UpdateUser="1"
			ts
			s sc=oobj.%Save()
			d oobj.%Close()	
			If $$$ISOK(sc)
			{	
				Tcommit
				K ^MEMUGOF(parcode,childcode)
			}
			else
			{
				Trollback
				S ^ERROR("菜单1",childcode)=parcode
			}
		}
	}
	
	k ^User.BDPExecutablesI
	d ##class(User.BDPExecutables).%BuildIndices()
	k ^User.BDPExtExecItemI
	d ##class(User.BDPExtExecItem).%BuildIndices()
	k ^User.BDPMenuI
	d ##class(User.BDPMenu).%BuildIndices()
	
	q "end"
}

/// w ##class(web.DHCBL.BDP.BDPMenuImport).KMENU()
ClassMethod KMENU() As %String
{
	k ^User.BDPExecutablesC
	k ^User.BDPExecutablesD
	k ^User.BDPExecutablesI
	k ^User.BDPExtExecItemI
	k ^User.BDPMenuD
	k ^User.BDPMenuI
	K ^ERROR("菜单")
	K ^ERROR("BDP功能大表")
	K ^ERROR("功能元素")
	Q "k"
}

/// w ##class(web.DHCBL.BDP.BDPMenuImport).ExportGof("D:\TMPMENU.gof")
ClassMethod ExportGof(path) As %String
{
	k ^TMPMENU
	///父表User.BDPExecutables  
	s id=0,code=""
	for {
		s id=$o(^User.BDPExecutablesD(id)) q:id=""
		s code=$LISTGET($G(^User.BDPExecutablesD(id)),4)
		if (code="") continue
		s ^TMPMENU("User.BDPExecutables",code)=^User.BDPExecutablesD(id)
		//子表User.BDPExtExecItem
		s sub=0,BDEFCode=""
		for {
			s sub=$o(^User.BDPExecutablesD(id,"ChildExtExecItem",sub))  q:sub=""
			s BDEFCode=$LISTGET($G(^User.BDPExecutablesD(id,"ChildExtExecItem",sub)),20)			
			if (BDEFCode="") continue
			s ^TMPMENU("User.BDPExtExecItem",code,BDEFCode)=^User.BDPExecutablesD(id,"ChildExtExecItem",sub)	
		}	
	}

	//^User.BDPMenuD
	s id=0,caption="",n=1  ///加n：菜单导入有先后
	for {
		s id=$o(^User.BDPMenuD(id)) q:id=""
		s code=$LISTGET($G(^User.BDPMenuD(id)),2)
		if code="" continue
		s LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(id)),4) ///功能
		s:LinkFuntionDR'="" LinkFuntionDR=$LISTGET($G(^User.BDPExecutablesD(LinkFuntionDR)),4)
		s:LinkFuntionDR="" LinkFuntionDR=0
		s ParentMenuDr=$LISTGET($G(^User.BDPMenuD(id)),11) // 父菜单 对应 菜单里的Caption
		s:ParentMenuDr'="" ParentMenuDr=$LISTGET($G(^User.BDPMenuD(ParentMenuDr)),2) //获取菜单描述
		s:ParentMenuDr="" ParentMenuDr=0
		s ^TMPMENU("User.BDPMenu",n,code,LinkFuntionDR,ParentMenuDr)=^User.BDPMenuD(id)
		s PLineDr=$listget($g(^User.BDPMenuD(id)),18)
		s:PLineDr'="" PLineDr=$listget($g(^User.DHCProductLineD(PLineDr)),2)
		s:PLineDr'="" ^TMPMENU("User.BDPMenu",n,code,LinkFuntionDR,ParentMenuDr,"PLineDr")=PLineDr
		s n=n+1
	}
	
	/*
	k myIdx
	k CList
	s items = ""
	s CList($i(CList))= "TMPMENU.GBL"
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","
		s items = items_CList(myIdx)
	}
	*/
	s items ="TMPMENU.GBL"
	
	d $SYSTEM.OBJ.Export(items, path, "", .log)
	q "success"
}

/// Other: d ##class(web.DHCBL.BDP.BDPMenuDefine).SaveEntityM()
ClassMethod SaveEntityM(eobj As web.Entity.BDP.BDPMenuDefine) As %String
{
 s:eobj.Sequence'="" eobj.Sequence=$ZCONVERT(eobj.Sequence,"U")
 ;s $zt="ERROE"
 s result="",flag=""
 if $IsObject(eobj)
 {
  s flag=##class(web.DHCBL.BDP.BDPMenuDefine).Validate(eobj.ID,eobj.Code)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.ID="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.BDPMenu).%New()
   }
   else                     //如果RowId已赋值则修改
   {
    s obj=##class(User.BDPMenu).%OpenId(eobj.ID)
    s bobj=##class(web.Entity.BDP.BDPMenuDefine).%New()
    s bobj.ID=eobj.ID
    s bobj.Code = obj.Code           
    s bobj.Caption = obj.Caption          
    s:obj.LinkFuntionDR'="" bobj.LinkFuntionDR=obj.LinkFuntionDR.%Id()
    s bobj.LinkUrl =  obj.LinkUrl
    s bobj.Image = obj.Image
    s bobj.Method = obj.Method
    s bobj.Sequence = obj.Sequence
    s bobj.ShortcutKey = obj.ShortcutKey
    s bobj.ShowInNewWindow = obj.ShowInNewWindow
    s:obj.ParentMenuDr'="" bobj.ParentMenuDr=obj.ParentMenuDr.%Id()
    s:obj.ProductLineDr'="" bobj.ProductLineDr=obj.ProductLineDr.%Id()
    s bobj.ValueExpression = obj.ValueExpression
    s bobj.CompName=obj.CompName
    if (obj.ActiveFlag){
    s bobj.actMenuBDP = $p(obj.ActiveFlag,"^",1)
    s bobj.actMenuAutItem=$p(obj.ActiveFlag,"^",2)
    s bobj.actMenuAutData=$p(obj.ActiveFlag,"^",3)
   }
 }  
   
   Ts
   s obj.Code = eobj.Code          //修改代码
   s obj.Caption = eobj.Caption          //修改描述
   d obj.LinkFuntionDRSetObjectId(eobj.LinkFuntionDR)
   s obj.LinkUrl = eobj.LinkUrl
   s obj.Image = eobj.Image
   s obj.Method = eobj.Method
   s obj.Sequence = eobj.Sequence
   s obj.ShortcutKey = eobj.ShortcutKey
   s obj.ShowInNewWindow = eobj.ShowInNewWindow
   d obj.ParentMenuDrSetObjectId(eobj.ParentMenuDr)
   d obj.ProductLineDrSetObjectId(eobj.ProductLineDr)
   s obj.UpdateDate = +$p($h,",",1)
   s obj.UpdateTime = +$p($h,",",2)
   //d obj.UpdateUserSetObjectId($Get(%session.Data("LOGON.USERID")))
   s obj.ValueExpression = eobj.ValueExpression
   s obj.CompName=eobj.CompName
   s ActiveFlag = ""
   if (eobj.actMenuBDP="1") {
    s $p(ActiveFlag,"^",1)="1"
   }else {
    s $p(ActiveFlag,"^",1)="0"
   }
   if (eobj.actMenuAutItem="1") {
    s $p(ActiveFlag,"^",2)="1"
   }else {
    s $p(ActiveFlag,"^",2)="0"
   }
   if (eobj.actMenuAutData="1") {
    s $p(ActiveFlag,"^",3)="1"
   }else {
    s $p(ActiveFlag,"^",3)="0"
   }
   s obj.ActiveFlag = ActiveFlag
  
     
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"  //返回RowId
    //保存日志
    ;d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Menu","User.BDPMenu","菜单定义",id,eobj.Caption,"A",eobj)
    ;d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Menu","User.BDPMenu","菜单定义",eobj.ID,eobj.Caption,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
   }
  }    
 }
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
 }
 q result
}

/// 去掉字符串末尾的空格
/// w ##class(web.DHCBL.BDP.BDPMenuImport).trim("    btnSearch    ")-->    btnSearch
ClassMethod trim(str) As %String
{
	While($e(str,*)=" ")
	{
		s str=$e(str,1,*-1)
	}
	q str
}

/// /w ##class(web.DHCBL.BDP.BDPMenuImport).k()
ClassMethod k() As %String
{
	//BI Glolba数据
	//k ^BDPMEMUEXCELPAR ///父菜单没导进去的菜单
	//k ^TMPMENU
	k ^User.BDPExecutablesC
	k ^User.BDPExecutablesD
	k ^User.BDPExecutablesI
	k ^User.BDPExtExecItemI
	k ^User.BDPMenuD
	k ^User.BDPMenuI
	q "SUCCESS"
}

/// /w ##class(web.DHCBL.BDP.BDPMenuImport).killPar()
ClassMethod killPar() As %String
{
	
	k ^BDPMEMUEXCELPAR ///父菜单没导进去的菜单
	q 1
}

/// /w ##class(web.DHCBL.BDP.BDPMenuImport).GetItemsCount()
ClassMethod GetItemsCount() As %String
{
	///s count=$g(^User.BDPExecutablesC("ChildExtExecItem"))
	k ^TMPITEMSCOUNT
	s count=0
	s id=0,code=""
	for {
		s id=$o(^User.BDPExecutablesD(id)) q:id=""
		s code=$LISTGET($G(^User.BDPExecutablesD(id)),4)
		s count=count+1
		s ^TMPITEMSCOUNT(count)=id
		//子表User.BDPExtExecItem
		s sub=0,BDEFCode=""
		for {
			s sub=$o(^User.BDPExecutablesD(id,"ChildExtExecItem",sub))  q:sub=""
			s BDEFCode=$LISTGET($G(^User.BDPExecutablesD(id,"ChildExtExecItem",sub)),20)
			s count=count+1			
			s ^TMPITEMSCOUNT(count)=id_"#"_sub
			
		}	
	}	
	q count
}

/// /w ##class(web.DHCBL.BDP.BDPMenuImport).GetExtItemInfo("2681")
ClassMethod GetExtItemInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPITEMSCOUNT(i))
	s ID=$p(idstr,"#",1)
	s sub=$p(idstr,"#",2)
	q:(ID="") ""
	s Code=$LISTGET($G(^User.BDPExecutablesD(ID)),4)
  	s Caption=$LISTGET($G(^User.BDPExecutablesD(ID)),3)
  	s Description=$LISTGET($G(^User.BDPExecutablesD(ID)),5)
  	s JavaScriptFile=$LISTGET($G(^User.BDPExecutablesD(ID)),6)
  	s BDAJavaScriptFile=$LISTGET($G(^User.BDPExecutablesD(ID)),7)
  	s PackageName=$LISTGET($G(^User.BDPExecutablesD(ID)),8)
  	s ClassName=$LISTGET($G(^User.BDPExecutablesD(ID)),9)
  	s PropertyName=$LISTGET($G(^User.BDPExecutablesD(ID)),10)
  	s ActiveFlag=$LISTGET($G(^User.BDPExecutablesD(ID)),2)
  	s str=Code_"#"_Caption_"#"_JavaScriptFile_"#"_BDAJavaScriptFile_"#"_Description_"#"_ActiveFlag_"#"_PackageName_"#"_ClassName_"#"_PropertyName
  	
  	if (sub'="")
  	{
  		s BDEFCode=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),20)
  		s BDEFName=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),37)
  		s BDEFAllowBlank=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),18)
  		s BDEFAutoShow=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),19)
  		s BDEFEditable=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),22)
  		s BDEFHandler=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),23)
  		s BDEFHidden=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),24)
 		s BDEFHiddenName=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),25)
 		s BDEFIconCls=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),26)
 		s BDEFReadOnly=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),27)
 		s BDEFRegex=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),28)
  		s BDEFRegexText=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),29)
 		s BDEFToolTip=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),30)
 		s BDEFToolTipType=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),31)
  		s BDEFType=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),32)
  		s BDEFValidator=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),33)
  		s BDEFValueGet=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),35)
  		s BDEFXType=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),34)
  		s BDEFValueSet=$LISTGET($G(^User.BDPExecutablesD(ID,"ChildExtExecItem",sub)),36)
  		s str=Code_"#"_Caption_"#"_JavaScriptFile_"#"_BDAJavaScriptFile_"#"_Description_"#"_ActiveFlag_"#"_PackageName_"#"_ClassName_"#"_PropertyName_"#"_BDEFCode_"#"_BDEFName_"#"_BDEFReadOnly_"#"_BDEFAllowBlank_"#"_BDEFHidden_"#"_BDEFEditable_"#"_BDEFToolTip_"#"_BDEFToolTipType_"#"_BDEFType_"#"_BDEFAutoShow_"#"_BDEFIconCls_"#"_BDEFHandler_"#"_BDEFXType_"#"_BDEFValidator_"#"_BDEFHiddenName_"#"_BDEFRegex_"#"_BDEFRegexText_"#"_BDEFValueGet_"#"_BDEFValueSet
	
  	}
  	
	q str
}

/// /w ##class(web.DHCBL.BDP.BDPMenuImport).GetMenuCount()
ClassMethod GetMenuCount() As %String
{
	///s count=$g(^User.BDPExecutablesC("ChildExtExecItem"))
	k ^TMPMENUCOUNT
    s count=0
	s id=0,code=""
	for {
		s id=$o(^User.BDPMenuD(id)) q:id=""
		s code=$LISTGET($G(^User.BDPMenuD(id)),2)
		s count=count+1
		s ^TMPMENUCOUNT(count)=id
	}	
	q count
}

/// /w ##class(web.DHCBL.BDP.BDPMenuImport).GetMenuInfo("610")
ClassMethod GetMenuInfo(i) As %String
{
	n (i)
	s str=""
	S id=$g(^TMPMENUCOUNT(i))
	q:(id="") ""
	s Code=$LISTGET($G(^User.BDPMenuD(id)),2)
 	s Caption=$LISTGET($G(^User.BDPMenuD(id)),3)
 	s LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(id)),4)
 	s:LinkFuntionDR'="" LinkFuntionDR=$LISTGET($G(^User.BDPExecutablesD(LinkFuntionDR)),4)
 	s LinkUrl=$LISTGET($G(^User.BDPMenuD(id)),5)
 	s Image=$LISTGET($G(^User.BDPMenuD(id)),6)
 	s Method=$LISTGET($G(^User.BDPMenuD(id)),7)
 	s Sequence=$LISTGET($G(^User.BDPMenuD(id)),8)
 	s ShortcutKey=$LISTGET($G(^User.BDPMenuD(id)),9)
 	s ShowInNewWindow=$LISTGET($G(^User.BDPMenuD(id)),10)
 	s ParentMenuDr=$LISTGET($G(^User.BDPMenuD(id)),11)
 	s ParentMenuDrCode="",ParentMenuDrDesc=""
 	s:ParentMenuDr'="" ParentMenuDrCode=$LISTGET($G(^User.BDPMenuD(ParentMenuDr)),2)
 	s:ParentMenuDr'="" ParentMenuDrDesc=$LISTGET($G(^User.BDPMenuD(ParentMenuDr)),3)
 	s ValueExpression=$LISTGET($G(^User.BDPMenuD(id)),15)
 	s ActiveFlag=$LISTGET($G(^User.BDPMenuD(id)),16)
 	s CompName=$LISTGET($G(^User.BDPMenuD(id)),17)
 	s ProductLineDr=$LISTGET($G(^User.BDPMenuD(id)),18)
 	s IsMKBMenu=$LISTGET($G(^User.BDPMenuD(id)),21)
 	s str=Code_"#"_Caption_"#"_LinkFuntionDR_"#"_LinkUrl_"#"_Image_"#"_Method_"#"_Sequence_"#"_ShortcutKey_"#"_ShowInNewWindow_"#"_ParentMenuDrCode_"#"_ParentMenuDrDesc_"#"_ActiveFlag_"#"_CompName_"#"_ProductLineDr_"#"_ValueExpression_"#"_IsMKBMenu
	q str
}

// dhc.bdp.System.MenuDefine#菜单维护#BDP_Menu#dhc.bdp.ext.default.csp#../scripts/bdp/Framework/BdpIconsLib/系统配置/菜单维护.png##4###dhc.bdp.System#####1^1^1##

/// /w ##class(web.DHCBL.BDP.BDPMenuImport).ImportExcel("菜单")
/// 0 失败，1修改/新增，2 数据相同 不操作
ClassMethod ImportExcel(sheetname, datastr) As %String
{
	s ^TMPCY=sheetname_","_datastr
	s result =0
	q:datastr="" 0
	if (sheetname["BDP功能大表") //User.BDPExecutables
	{
		s Code=$p(datastr,"#",1)
		q:Code="" result
		s Code1=..trim(Code)
		s flag=$d(^User.BDPExecutablesI("CodeIndex"," "_$zcvt(Code1,"U")))
		if (flag>0)
		{
			s id=$o(^User.BDPExecutablesI("CodeIndex"," "_$zcvt(Code1,"U"),0))
			s oobj=##class(User.BDPExecutables).%OpenId(id)
			////判断是否和原数据一样，一样则不修改
			
   			s cstrnew="{list:[{Code:"""_$p(datastr,"#",1)_""",Caption:"""_$p(datastr,"#",2)_""",JavaScriptFile:"""_$p(datastr,"#",3)_""",BDAJavaScriptFile:"""_$p(datastr,"#",4)_""",Description:"""_$p(datastr,"#",5)_""",ActiveFlag:"""_$p(datastr,"#",6)_""",PackageName:"""_$p(datastr,"#",7)_""",ClassName:"""_$p(datastr,"#",8)_""",PropertyName:"""_$p(datastr,"#",9)_""",ID:"""_id_"""}]}"
   			s cstrold="{list:[{Code:"""_oobj.Code_""",Caption:"""_oobj.Caption_""",JavaScriptFile:"""_oobj.JavaScriptFile_""",BDAJavaScriptFile:"""_oobj.BDAJavaScriptFile_""",Description:"""_oobj.Description_""",ActiveFlag:"""_oobj.ActiveFlag_""",PackageName:"""_oobj.PackageName_""",ClassName:"""_oobj.ClassName_""",PropertyName:"""_oobj.PropertyName_""",ID:"""_id_"""}]}"
   			d oobj.%Close()
   			if (cstrnew=cstrold)
   			{
	   			s result=2 ///跳过修改
   			}
   			else
   			{
	   			///修改
	   			s eobj=##class(web.Entity.BDP.BDPExecutables).%New()
   				s eobj.ID=id
				s eobj.Code = $p(datastr,"#",1)
   				s eobj.Caption = $p(datastr,"#",2)
   				s eobj.JavaScriptFile =$p(datastr,"#",3)
   				s eobj.BDAJavaScriptFile =$p(datastr,"#",4)
   				s eobj.Description = $p(datastr,"#",5)
   				s eobj.ActiveFlag=$p(datastr,"#",6)
   				s eobj.PackageName=$p(datastr,"#",7)
   				s eobj.ClassName=$p(datastr,"#",8)    
   				s eobj.PropertyName=$p(datastr,"#",9)
   				s estr=##class(web.DHCBL.BDP.BDPExecutables).SaveEntity(eobj)
   				if (estr["success:'true'")
				{
   					 s result=1
				}
				if (estr["success:'false'")
				{
					s result=0
					s ^BDPEXTEXCELERROR($p(datastr,"#",1),$p(datastr,"#",2))=datastr
				}
   			
   			}
   			
   			
   			//功能元素
			s BDEFCode = $p(datastr,"#",10)
			q:BDEFCode="" result 
			S BDEFCode1=..trim(BDEFCode)
			s idd=$o(^User.BDPExtExecItemI("CodeIndex"," "_$zcvt(BDEFCode1,"U"),id,0))
			if (idd>0)
			{
				s BDEFID=id_"||"_idd
				s itemoobj=##class(User.BDPExtExecItem).%OpenId(BDEFID)
				////判断是否和原数据一样，一样则不修改
			
   				s cstritemnew="{list:[{BDEFCode:"""_$p(datastr,"#",10)_""",BDEFName:"""_$p(datastr,"#",11)_""",BDEFReadOnly:"""_$p(datastr,"#",12)_""",BDEFAllowBlank:"""_$p(datastr,"#",13)_""",BDEFHidden:"""_$p(datastr,"#",14)_""",BDEFEditable:"""_$p(datastr,"#",15)_""",BDEFToolTip:"""_$p(datastr,"#",16)_""",BDEFToolTipType:"""_$p(datastr,"#",17)_""",BDEFType:"""_$p(datastr,"#",18)_""",BDEFAutoShow:"""_$p(datastr,"#",19)_""",BDEFIconCls:"""_$p(datastr,"#",20)_""",BDEFHandler:"""_$p(datastr,"#",21)_""",BDEFXType:"""_$p(datastr,"#",22)_""",BDEFValidator:"""_$p(datastr,"#",23)_""",BDEFHiddenName:"""_$p(datastr,"#",24)_""",BDEFRegex:"""_$p(datastr,"#",25)_""",BDEFRegexText:"""_$p(datastr,"#",26)_""",BDEFValueGet:"""_$p(datastr,"#",27)_""",BDEFValueSet:"""_$p(datastr,"#",28)_""",BDEFRowId:"""_BDEFID_"""}]}"
   				s cstritemold="{list:[{BDEFCode:"""_itemoobj.Code_""",BDEFName:"""_itemoobj.Name_""",BDEFReadOnly:"""_itemoobj.ReadOnly_""",BDEFAllowBlank:"""_itemoobj.AllowBlank_""",BDEFHidden:"""_itemoobj.Hidden_""",BDEFEditable:"""_itemoobj.Editable_""",BDEFToolTip:"""_itemoobj.ToolTip_""",BDEFToolTipType:"""_itemoobj.ToolTipType_""",BDEFType:"""_itemoobj.Type_""",BDEFAutoShow:"""_itemoobj.AutoShow_""",BDEFIconCls:"""_itemoobj.IconCls_""",BDEFHandler:"""_itemoobj.Handler_""",BDEFXType:"""_itemoobj.XType_""",BDEFValidator:"""_itemoobj.Validator_""",BDEFHiddenName:"""_itemoobj.HiddenName_""",BDEFRegex:"""_itemoobj.Regex_""",BDEFRegexText:"""_itemoobj.RegexText_""",BDEFValueGet:"""_itemoobj.ValueGet_""",BDEFValueGet:"""_itemoobj.ValueGet_""",BDEFRowId:"""_BDEFID_"""}]}"
   				d itemoobj.%Close()
   				if (cstritemnew=cstritemold)
   				{
	   				q result=2 ///数据相同，跳过
   				}	
   				else
   				{
	   				//数据不同，修改
	   				s eobj1=##class(web.Entity.BDP.BDPExtExecItem).%New()
					s eobj1.BDEFRowId=BDEFID
					s eobj1.BDEFBDETParRef=id
					s eobj1.BDEFCode = $p(datastr,"#",10)
   					s eobj1.BDEFName = $p(datastr,"#",11)
   					s eobj1.BDEFReadOnly = $p(datastr,"#",12)
  					s eobj1.BDEFAllowBlank = $p(datastr,"#",13)
  					s eobj1.BDEFHidden = $p(datastr,"#",14)
  					s eobj1.BDEFEditable = $p(datastr,"#",15)
  					s eobj1.BDEFToolTip =$p(datastr,"#",16)
   					s eobj1.BDEFToolTipType = $p(datastr,"#",17)
   					s eobj1.BDEFType =$p(datastr,"#",18)
   					s eobj1.BDEFAutoShow = $p(datastr,"#",19)
  					s eobj1.BDEFIconCls =$p(datastr,"#",20)
   					s eobj1.BDEFHandler = $p(datastr,"#",21)
   					s eobj1.BDEFXType = $p(datastr,"#",22)
   					s eobj1.BDEFValidator = $p(datastr,"#",23)
   					s eobj1.BDEFHiddenName = $p(datastr,"#",24)
   					s eobj1.BDEFRegex =$p(datastr,"#",25)
   					s eobj1.BDEFRegexText = $p(datastr,"#",26)
   					s eobj1.BDEFValueGet = $p(datastr,"#",27)
   					s eobj1.BDEFValueSet = $p(datastr,"#",28)
   					s estr1=##class(web.DHCBL.BDP.BDPExtExecItem).SaveEntity(eobj1)
   					if (estr1["success:'true'")
   					{
	   					 s result=1
   					}
					if (estr1["success:'false'")
					{
						s result=0
						s ^BDPITEMSEXCELERROR($p(datastr,"#",1),$p(datastr,"#",2))=datastr
					}
   				}
			}
			else
			{
				//功能元素新增
				s eobj1=##class(web.Entity.BDP.BDPExtExecItem).%New()
				s eobj1.BDEFRowId=""
				s eobj1.BDEFBDETParRef=id
				s eobj1.BDEFCode = $p(datastr,"#",10)
				s eobj1.BDEFName = $p(datastr,"#",11)
				s eobj1.BDEFReadOnly = $p(datastr,"#",12)
				s eobj1.BDEFAllowBlank = $p(datastr,"#",13)
				s eobj1.BDEFHidden = $p(datastr,"#",14)
				s eobj1.BDEFEditable = $p(datastr,"#",15)
				s eobj1.BDEFToolTip =$p(datastr,"#",16)
				s eobj1.BDEFToolTipType = $p(datastr,"#",17)
				s eobj1.BDEFType =$p(datastr,"#",18)
				s eobj1.BDEFAutoShow = $p(datastr,"#",19)
  				s eobj1.BDEFIconCls =$p(datastr,"#",20)
   				s eobj1.BDEFHandler = $p(datastr,"#",21)
   				s eobj1.BDEFXType = $p(datastr,"#",22)
   				s eobj1.BDEFValidator = $p(datastr,"#",23)
   				s eobj1.BDEFHiddenName = $p(datastr,"#",24)
   				s eobj1.BDEFRegex =$p(datastr,"#",25)
   				s eobj1.BDEFRegexText = $p(datastr,"#",26)
   				s eobj1.BDEFValueGet = $p(datastr,"#",27)
   				s eobj1.BDEFValueSet = $p(datastr,"#",28)
   				s estr1=##class(web.DHCBL.BDP.BDPExtExecItem).SaveEntity(eobj1)
   				if (estr1["success:'true'")
   				{
	   				 s result=1
   				}
				if (estr1["success:'false'")
				{
					s result=0
					s ^BDPITEMSEXCELERROR($p(datastr,"#",1),$p(datastr,"#",2))=datastr
				}	
			}
		}
		else
		{	
			//BDP功能大表新增
			s eobj=##class(web.Entity.BDP.BDPExecutables).%New()
			s eobj.ID=""
			s eobj.Code = $p(datastr,"#",1)
			s eobj.Caption = $p(datastr,"#",2)
			s eobj.JavaScriptFile =$p(datastr,"#",3)
			s eobj.BDAJavaScriptFile =$p(datastr,"#",4)
			s eobj.Description = $p(datastr,"#",5)
			s eobj.ActiveFlag=$p(datastr,"#",6)
			s eobj.PackageName=$p(datastr,"#",7)
			s eobj.ClassName=$p(datastr,"#",8)    
			s eobj.PropertyName=$p(datastr,"#",9)
			s estr=##class(web.DHCBL.BDP.BDPExecutables).SaveEntity(eobj)
			if (estr["success:'true'")
			{
				s result=1
				s id=$p($p(estr,"id:'",2),"'",1)
				s BDEFCode = $p(datastr,"#",10)
				q:BDEFCode="" result
				s BDEFCode1=..trim(BDEFCode)
				s idd=$o(^User.BDPExtExecItemI("CodeIndex"," "_$zcvt(BDEFCode1,"U"),id,0))
				if (idd>0)
				{
					s result =0
				}
				else
				{
					s eobj1=##class(web.Entity.BDP.BDPExtExecItem).%New()
					s eobj1.BDEFRowId=""
					s eobj1.BDEFBDETParRef=id
					s eobj1.BDEFCode = $p(datastr,"#",10)
					s eobj1.BDEFName = $p(datastr,"#",11)
					s eobj1.BDEFReadOnly = $p(datastr,"#",12)
					s eobj1.BDEFAllowBlank = $p(datastr,"#",13)
					s eobj1.BDEFHidden = $p(datastr,"#",14)
					s eobj1.BDEFEditable = $p(datastr,"#",15)
					s eobj1.BDEFToolTip =$p(datastr,"#",16)
					s eobj1.BDEFToolTipType = $p(datastr,"#",17)
					s eobj1.BDEFType =$p(datastr,"#",18)
					s eobj1.BDEFAutoShow = $p(datastr,"#",19)
  					s eobj1.BDEFIconCls =$p(datastr,"#",20)
   					s eobj1.BDEFHandler = $p(datastr,"#",21)
   					s eobj1.BDEFXType = $p(datastr,"#",22)
   					s eobj1.BDEFValidator = $p(datastr,"#",23)
   					s eobj1.BDEFHiddenName = $p(datastr,"#",24)
   					s eobj1.BDEFRegex =$p(datastr,"#",25)
   					s eobj1.BDEFRegexText = $p(datastr,"#",26)
   					s eobj1.BDEFValueGet = $p(datastr,"#",27)
   					s eobj1.BDEFValueSet = $p(datastr,"#",28)
   					s estr1=##class(web.DHCBL.BDP.BDPExtExecItem).SaveEntity(eobj1)
   					if (estr1["success:'true'")
   					{
	   					 s result=1
   					}
					if (estr1["success:'false'")
					{
						s result=0
						s ^BDPITEMSEXCELERROR($p(datastr,"#",1),$p(datastr,"#",2))=datastr
					}
				}
				 
			}
			if (estr["success:'false'")
			{
				s result=0
				s ^BDPEXTEXCELERROR($p(datastr,"#",1),$p(datastr,"#",2))=datastr
			}
			
		}
		
	}
	if (sheetname["菜单") //User.BDPMenu
	{
		//KPICode	KPIName	MetxType	PivotFilter	ClassName	SubjectName
		s Code=$p(datastr,"#",1)
		q:Code="" result
		S Code1=..trim(Code)
		s flag=$d(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(Code1,"U")))
		if (flag>0)
		{
			s menuid=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(Code1,"U"),0))
			q:menuid="" 0
			s menuoobj=##class(User.BDPMenu).%OpenId(menuid)
			s LinkFuntionDR=$p(datastr,"#",3)
   			s:LinkFuntionDR'="" LinkFuntionDRID=$o(^User.BDPExecutablesI("CodeIndex"," "_$ZCONVERT(LinkFuntionDR,"U"),0))
			s:LinkFuntionDR="" LinkFuntionDRID=""
			s ParentMenuDr=$p(datastr,"#",10)
			s ParentMenuDr1=..trim(ParentMenuDr)
  			s:ParentMenuDr'="" ParentMenuDrID=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$ZCONVERT(ParentMenuDr1,"U"),0))
			s:ParentMenuDr="" ParentMenuDrID=""
			//////有些是先建子菜单，再建父菜单，再把子菜单指向父菜单的，要等保存完所有菜单后再处理这些
			if ((ParentMenuDr'="")&(ParentMenuDrID="")) s ^BDPMEMUEXCELPAR(ParentMenuDr,$p(datastr,"#",1),$p(datastr,"#",2))=""
			s ProductLineDr=$p(datastr,"#",14)
   			s:ProductLineDr'="" ProductLineDrID=$o(^User.DHCProductLineI("CodeIndex"," "_$zcvt(ProductLineDr,"U"),0))
   			s:ProductLineDr="" ProductLineDrID=""
			
			
			s:LinkFuntionDRID'="" LinkFuntionDRIDS=LinkFuntionDRID
			s:ProductLineDrID'="" ProductLineDrIDS=ProductLineDrID
			s:ParentMenuDrID'="" ParentMenuDrIDS=ParentMenuDrID
			s:LinkFuntionDRID="" LinkFuntionDRIDS=""
			s:ProductLineDrID="" ProductLineDrIDS=""
			s:ParentMenuDrID="" ParentMenuDrIDS=""
			////↓如果是menuoobj.dr =4@User.BDPMenu 与实际的91值不同
			s strold="{list:[{Caption:'"_menuoobj.Caption_"',Code:'"_menuoobj.Code_"',CompName:'"_menuoobj.CompName_"',ID:'"_menuid_"',Image:'"_menuoobj.Image_"',LinkFuntionDR:'"_$LISTGET($G(^User.BDPMenuD(menuid)),4)_"',LinkUrl:'"_menuoobj.LinkUrl_"',Method:'"_menuoobj.Method_"',ParentMenuDr:'"_$LISTGET($G(^User.BDPMenuD(menuid)),11)_"',ProductLineDr:'"_$LISTGET($G(^User.BDPMenuD(menuid)),18)_"',Sequence:'"_menuoobj.Sequence_"',ShortcutKey:'"_menuoobj.ShortcutKey_"',ShowInNewWindow:'"_menuoobj.ShowInNewWindow_"',ValueExpression:'"_menuoobj.ValueExpression_"',ActiveFlag:'"_menuoobj.ActiveFlag_"',IsMKBMenu:'"_menuoobj.IsMKBMenu_"'}]}"
			
			s strnew="{list:[{Caption:'"_$p(datastr,"#",2)_"',Code:'"_$p(datastr,"#",1)_"',CompName:'"_$p(datastr,"#",13)_"',ID:'"_menuid_"',Image:'"_$p(datastr,"#",5)_"',LinkFuntionDR:'"_LinkFuntionDRIDS_"',LinkUrl:'"_$p(datastr,"#",4)_"',Method:'"_$p(datastr,"#",6)_"',ParentMenuDr:'"_ParentMenuDrIDS_"',ProductLineDr:'"_ProductLineDrIDS_"',Sequence:'"_$p(datastr,"#",7)_"',ShortcutKey:'"_$p(datastr,"#",8)_"',ShowInNewWindow:'"_$p(datastr,"#",9)_"',ValueExpression:'"_$p(datastr,"#",15)_"',ActiveFlag:'"_$p(datastr,"#",12)_"',IsMKBMenu:'"_$p(datastr,"#",16)_"'}]}"
			if (strold=strnew)
			{
				s result=2 ///数据相同，跳过
			}	
			else
			{
				s eobj2=##class(web.Entity.BDP.BDPMenuDefine).%New()
				s eobj2.ID = menuid
				s eobj2.Code = $p(datastr,"#",1)
   				s eobj2.Caption = $p(datastr,"#",2)
   				s eobj2.LinkFuntionDR=LinkFuntionDRID
   				s eobj2.LinkUrl = $p(datastr,"#",4)
   				s eobj2.Image = $p(datastr,"#",5)
  				s eobj2.Method =$p(datastr,"#",6)
  				s eobj2.Sequence = $p(datastr,"#",7)
  				s eobj2.ShortcutKey = $p(datastr,"#",8)
  				s eobj2.ShowInNewWindow = $p(datastr,"#",9)
  				s eobj2.ParentMenuDr=ParentMenuDrID
  				s eobj2.UpdateDate = +$h
  				s eobj2.UpdateTime = $p($h,",",2)
   				s eobj2.UpdateUser=$Get(%session.Data("LOGON.USERID"))
   				s eobj2.ValueExpression = $p(datastr,"#",15)
   				s eobj2.ActiveFlag = $p(datastr,"#",12)
   				s eobj2.actMenuBDP= $p(eobj2.ActiveFlag,"^",1)
   				s eobj2.actMenuAutItem= $p(eobj2.ActiveFlag,"^",2)
   				s eobj2.actMenuAutData= $p(eobj2.ActiveFlag,"^",3)
   				s eobj2.CompName=$p(datastr,"#",13)
   				s eobj2.ProductLineDr=ProductLineDrID
   				s eobj2.IsMKBMenu=$p(datastr,"#",16)
   				s estr2=##class(web.DHCBL.BDP.BDPMenuDefine).SaveEntity(eobj2)
   				if (estr2["success:'true'")
				{
   					 s result=1
				}
				if (estr2["success:'false'")
				{
					s result=0
					s ^BDPMENUEXCELERROR($p(datastr,"#",1),$p(datastr,"#",2))=datastr
				}
			}	
		}
		else
		{
			s LinkFuntionDR=$p(datastr,"#",3)
   			s:LinkFuntionDR'="" LinkFuntionDRID=$o(^User.BDPExecutablesI("CodeIndex"," "_$ZCONVERT(LinkFuntionDR,"U"),0))
			s:LinkFuntionDR="" LinkFuntionDRID=""
			s ParentMenuDr=$p(datastr,"#",10)
			s ParentMenuDr1=..trim(ParentMenuDr)
  			s:ParentMenuDr'="" ParentMenuDrID=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$ZCONVERT(ParentMenuDr1,"U"),0))
			s:ParentMenuDr="" ParentMenuDrID=""
			//////有些是先建子菜单，再建父菜单，再把子菜单指向父菜单的，要等保存完所有菜单后再处理这些
			if ((ParentMenuDr'="")&(ParentMenuDrID="")) s ^BDPMEMUEXCELPAR(ParentMenuDr,$p(datastr,"#",1),$p(datastr,"#",2))=""
			s ProductLineDr=$p(datastr,"#",14)
   			s:ProductLineDr'="" ProductLineDrID=$o(^User.DHCProductLineI("CodeIndex"," "_$zcvt(ProductLineDr,"U"),0))
   			s:ProductLineDr="" ProductLineDrID=""
			s eobj2=##class(web.Entity.BDP.BDPMenuDefine).%New()
			s eobj2.ID = ""
			s eobj2.Code = $p(datastr,"#",1)
			s eobj2.Caption = $p(datastr,"#",2)
			s eobj2.LinkFuntionDR=LinkFuntionDRID
			s eobj2.LinkUrl = $p(datastr,"#",4)
			s eobj2.Image = $p(datastr,"#",5)
			s eobj2.Method =$p(datastr,"#",6)
			s eobj2.Sequence = $p(datastr,"#",7)
			s eobj2.ShortcutKey = $p(datastr,"#",8)
			s eobj2.ShowInNewWindow = $p(datastr,"#",9)
			s eobj2.ParentMenuDr=ParentMenuDrID
			s eobj2.UpdateDate = +$p($h,",",1)
			s eobj2.UpdateTime = +$p($h,",",2)
			s eobj2.UpdateUser=$Get(%session.Data("LOGON.USERID"))
			s eobj2.ValueExpression = $p(datastr,"#",15)
			s eobj2.ActiveFlag = $p(datastr,"#",12)
			s eobj2.actMenuBDP= $p(eobj2.ActiveFlag,"^",1)
   			s eobj2.actMenuAutItem= $p(eobj2.ActiveFlag,"^",2)
   			s eobj2.actMenuAutData= $p(eobj2.ActiveFlag,"^",3)
			s eobj2.CompName=$p(datastr,"#",13)
			s eobj2.ProductLineDr=ProductLineDrID
			s eobj2.IsMKBMenu=$p(datastr,"#",16)
			s estr2=##class(web.DHCBL.BDP.BDPMenuDefine).SaveEntity(eobj2)
			
			if (estr2["success:'true'")
			{
				 s result=1
			}
			if (estr2["success:'false'")
			{
				s result=0
				s ^BDPMENUEXCELERROR($p(datastr,"#",1),$p(datastr,"#",2))=datastr
			}				
		}	
	}
	q result
}

/// /w ##class(web.DHCBL.BDP.BDPMenuImport).ReImportParentMenuDr()
ClassMethod ReImportParentMenuDr() As %String
{
	s parcode=""
	for
	{		
		s parcode=$o(^BDPMEMUEXCELPAR(parcode)) q:parcode=""
		s parcode1=..trim(parcode)
		s parid= $o(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(parcode1,"U"),0))
		continue:parid=""
		s childcode=0
		for 
		{
			s childcode=$o(^BDPMEMUEXCELPAR(parcode,childcode)) q:childcode=""
			S childcode1=..trim(childcode)  ////code末尾为多个空格，但是保存后的索引里末尾不带空格，开头可以带空格
			s childid=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(childcode1,"U"),0))
			Q:childid=""
			s oobj=##class(User.BDPMenu).%OpenId(childid)
			d oobj.ParentMenuDrSetObjectId(parid)
  			s oobj.UpdateDate = +$p($h,",",1)
			s oobj.UpdateTime = +$p($h,",",2)
			//s oobj.UpdateUser="1"
			d oobj.UpdateUserSetObjectId($g(%session.Data("LOGON.USERID")))
			ts
			s sc=oobj.%Save()
			d oobj.%Close()	
			If $$$ISOK(sc)
			{	
				Tcommit
				K ^BDPMEMUEXCELPAR(parcode,childcode)
			}
			else
			{
				Trollback
				S ^ERROR("菜单excel",childcode)=parcode
			}
		}
	}
	q 0
}

ClassMethod ValidateI(ParentRowId As %String, id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$ZCONVERT(code,"U")
 s:desc'="" desc=$zcvt(desc,"U")
 s flag=""
 if (id="") //如果为空，增加时的重复判断
 {
  s flagc="",flagD=0
  s:code'="" flagc=$d(^User.BDPExtExecItemI("CodeIndex"," "_code,ParentRowId))
  s ID=0
  for
  {
    s ID=$o(^User.BDPExecutablesD(ParentRowId,"ChildExtExecItem",ID)) 
    q:ID=""  
    s BDEFName=$LISTGET($G(^User.BDPExecutablesD(ParentRowId,"ChildExtExecItem",ID)),37)
    if ($zcvt(BDEFName,"U")=desc) s flagD=1
    else  continue
  }
  if (flagc>0)  s flagc=1
 }
 else //如果不为空，修改时的重复判断
 {
  s ParRef=$p(id,"||",1)
  s subId=$p(id,"||",2)
  s flagc=0
  s:code'="" flagc=$d(^User.BDPExtExecItemI("CodeIndex"," "_code,ParRef))
  s idc=""
  s:code'="" idc=$o(^User.BDPExtExecItemI("CodeIndex"," "_code,ParRef,0))
  s ID=0,flagD=0
  for
  {
    s ID=$o(^User.BDPExecutablesD(ParentRowId,"ChildExtExecItem",ID)) 
    q:ID=""  
    s BDEFName=$LISTGET($G(^User.BDPExecutablesD(ParentRowId,"ChildExtExecItem",ID)),37)
    s BDEFRowId=ParentRowId_"||"_ID
    if ($zcvt(BDEFName,"U")=desc)&(BDEFRowId'=id) s flagD=1
    else  continue
  }
  if ((idc'=subId)&(flagc>0))
  {
    s flagc=1
  }
  else
  {
    s flagc=0
  }
 }
 s flag=flagc_"^"_ flagD
 q flag
}

/// Others: d ##class(web.DHCBL.BDP.BDPExtExecItem).SaveEntity()
ClassMethod SaveEntityI(eobj As web.Entity.BDP.BDPExtExecItem) As %String
{
 s result="",codeflag=0,descflag=0
 if $IsObject(eobj)
 {
  s flag=..ValidateI(eobj.BDEFBDETParRef,eobj.BDEFRowId,eobj.BDEFCode,eobj.BDEFName)  //调用重复验证
  if (flag="1^1")||(flag="0^1")||(flag="1^0")
  {
    s codeflag=$p(flag,"^",1)
    s descflag=$p(flag,"^",2)
    if (codeflag=1)&(descflag=0){
      s result = "{success:'false',errorinfo:'该条记录代码重复！'}"
    }
    if (codeflag=0)&(descflag=1){
     s result = "{success:'false',errorinfo:'该条记录描述重复！'}"
    }
    if (codeflag=1)&(descflag=1){
     s result = "{success:'false',errorinfo:'该条记录代码和描述重复！'}"
    }
  }
  else
  {
   if (eobj.BDEFRowId="")       //如果RowId未赋值则增加
   {
    s obj=##class(User.BDPExtExecItem).%New(eobj.BDEFBDETParRef)
  
   }
   else                                                  //如果RowId已赋值则修改
   {
    s obj=##class(User.BDPExtExecItem).%OpenId(eobj.BDEFRowId)
   }
   Ts        
   d:eobj.BDEFBDETParRef'="" obj.ParRefSetObjectId(eobj.BDEFBDETParRef) //修改数据时BDEFBDETParRef为空
   s obj.Code = eobj.BDEFCode
   s obj.Name = eobj.BDEFName
   s obj.AllowBlank = eobj.BDEFAllowBlank
   s obj.AutoShow = eobj.BDEFAutoShow
   s obj.Editable = eobj.BDEFEditable
   s obj.Handler = eobj.BDEFHandler
   s obj.Hidden = eobj.BDEFHidden
   s obj.HiddenName = eobj.BDEFHiddenName
   s obj.IconCls = eobj.BDEFIconCls
   s obj.ReadOnly = eobj.BDEFReadOnly
   s obj.Regex = eobj.BDEFRegex
   s obj.RegexText = eobj.BDEFRegexText
   s obj.ToolTip = eobj.BDEFToolTip
   s obj.ToolTipType = eobj.BDEFToolTipType
   s obj.Type = eobj.BDEFType
   s obj.XType = eobj.BDEFXType
   s obj.Validator = eobj.BDEFValidator
   s obj.ValueGet = eobj.BDEFValueGet
   s obj.ValueSet = eobj.BDEFValueSet
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc){
    Tc
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.BDEFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPExtExecItem","User.BDPExtExecItem","基本元素",id,eobj.BDEFName,"A",eobj)
    d:eobj.BDEFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPExtExecItem","User.BDPExtExecItem","基本元素",eobj.BDEFRowId,eobj.BDEFName,"U",eobj)
   }else{
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
   }
  }
 }
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
 q result
}

ClassMethod ValidateE(id As %String, code As %String) As %String
{
   s:code'="" code=$ZCONVERT(code,"U") //转换成大写
   s flag="",flagc=""
   s:code'="" flagc=$d(^User.BDPExecutablesI("CodeIndex"," "_code))
   if (id="") //如果为空，增加时的重复判断
   {
     if (flagc>0) s flag=1  //返回重复标志
     else  s flag=0 //返回不重复标志
   }
  else //如果不为空，修改时的重复判断
  {
   s idc=""
   s:code'="" idc=$o(^User.BDPExecutablesI("CodeIndex"," "_code,0))
   if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
 q flag
}

/// Debug: d ##class(web.DHCBL.BDP.BDPExecutables).SaveEntity()
ClassMethod SaveEntityE(eobj As web.Entity.BDP.BDPExecutables) As %String
{
  s result="",ClassFlag=""
  s ValidateFlag=""
  if $IsObject(eobj)
  { 
    s flag=..ValidateE(eobj.ID,eobj.Code)   
    if (flag=1)
    {
     s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
     if ((eobj.PropertyName'="")&&(eobj.ClassName =""))
     {
       s result= "{success:'false',errorinfo:'显示字段名非空时，类名不能为空!'}"
       q result
     }
     else
     {
       if ((eobj.ClassName'="")&(eobj.ClassName'["^"))
       {
         s ClassFlag=##class(web.DHCBL.BDP.FindTableStructure).ClassExistOrNot(eobj.ClassName) 
         if (ClassFlag=0)
         {
           s result= "{success:'false',errorinfo:'实体类不存在，请重新填写类名称!'}"
           q result
         }
        else
        {
         s ValidateFlag=##class(web.DHCBL.BDP.FindTableStructure).PropertyExistOrNot(eobj.ClassName,eobj.PropertyName) 
         if (ValidateFlag=0)
         {
           s result= "{success:'false',errorinfo:'显示字段名在类中不存在，请核查显示字段名是否正确!'}"
           q result
         }
       }
   }
}
 
   if (eobj.ID="")  //如果RowId未赋值则增加
   { 
     s obj=##class(User.BDPExecutables).%New()
   }
   else   //如果RowId已赋值则修改
   {
     s obj=##class(User.BDPExecutables).%OpenId(eobj.ID)
     s bobj=##class(web.Entity.BDP.BDPExecutables).%New()
     s bobj.Code = obj.Code                      
     s bobj.Caption = obj.Caption                      
     s bobj.JavaScriptFile = obj.JavaScriptFile   
     s bobj.Description = obj.Description                  
     s bobj.BDAJavaScriptFile = obj.BDAJavaScriptFile
     s bobj.ClassName= obj.ClassName                  
     s bobj.PropertyName=obj.PropertyName
     s bobj.ID=eobj.ID    
     s bobj.PackageName=obj.PackageName
     s bobj.ActiveFlag=obj.ActiveFlag
     s:bobj.ActiveFlag=1 bobj.ActiveFlag="Y"
     s:bobj.ActiveFlag=0 bobj.ActiveFlag="N"
   }
   s:eobj.Code'="" eobj.Code=$tr(eobj.Code," ","")   ; 去除空格
   s:eobj.JavaScriptFile'="" eobj.JavaScriptFile=$tr(eobj.JavaScriptFile," ","")
   s:eobj.BDAJavaScriptFile'="" eobj.BDAJavaScriptFile=$tr(eobj.BDAJavaScriptFile," ","")
   s:eobj.ActiveFlag="Y" eobj.ActiveFlag=1  ///ActiveFlag 为 布尔类型： 0 或 1
   s:eobj.ActiveFlag="N" eobj.ActiveFlag=0
   s:eobj.ActiveFlag="" eobj.ActiveFlag=0
   s obj.Code = eobj.Code                      
   s obj.Caption = eobj.Caption                      //修改描述
   s obj.JavaScriptFile = eobj.JavaScriptFile  //JS文件及路径
   s obj.Description = eobj.Description        // 功能描述
   s obj.BDAJavaScriptFile = eobj.BDAJavaScriptFile  /// 基础数据授权 js 路径
   s obj.ClassName= eobj.ClassName          /// 类名              
   s obj.PropertyName=eobj.PropertyName     ////显示字段名称
   s obj.PackageName=eobj.PackageName  /// 包名称
   s obj.ActiveFlag=eobj.ActiveFlag  /// 有效
   Ts
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
     Tc
     s id = obj.%Id()
     s result = "{success:'true',id:'"_id_"'}"         
     //保存日志
     d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Executables","User.BDPExecutables","Ext功能大表",id,eobj.Caption,"A",eobj)
     d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Executables","User.BDPExecutables","Ext功能大表",eobj.ID,eobj.Caption,"U",eobj,bobj)
   }
   else
   {
      Trollback
      s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
   }
  }
 }
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
  q result
}

/// /code相同的跳过 
/// 从D:\文件夹下 导入知识库数据TMPBIKB.gof
/// w ##class(web.DHCBL.BDP.BDPMenuImport).ImportGof2("D:\tmp\TMPMENU.gof")
ClassMethod ImportGof2(path) As %String
{
	n (path)
	if path'[".gof"   q "请选择正确的gof文件"
	
 	s existflag=##class(%File).Exists(path)
	if existflag=0 q "gof文件不存在"
	
	if (path["\") 
	{
		s filename=$p(path,"\",$l(path,"\"))
	}	
	if (path["/")
	{
		s filename=$p(path,"/",$l(path,"/"))
	}
	s length=$l(filename)
 	s packagename=$e(path,1,*-length)
 	
 	k ^TMPMENU
 	k ^BDPMEMUGOFPAR
 	
	d $SYSTEM.OBJ.ImportDir(packagename, filename)
	
	//User.BDPExecutables
	s code="",flag=0
	for {
		s code=$o(^TMPMENU("User.BDPExecutables",code)) q:code=""
		s code1= ..trim(code)   ///去掉末尾空格
		s flag=$d(^User.BDPExecutablesI("CodeIndex"," "_$ZCONVERT(code1,"U")))
		i flag=10 continue

  		s JavaScriptFile=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),6)
  		s BDAJavaScriptFile=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),7)
   		//s:Code1'="" Code1=$tr(Code1," ","")   ; 去除空格
   		//s:JavaScriptFile'="" JavaScriptFile=$tr(JavaScriptFile," ","")
   		//s:BDAJavaScriptFile'="" BDAJavaScriptFile=$tr(BDAJavaScriptFile," ","")
   		
   		s obj=##class(User.BDPExecutables).%New()
   		s obj.Code = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),4)
   		s obj.Caption = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),3)
   		s obj.JavaScriptFile = JavaScriptFile
  		s obj.Description = $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),5)
   		s obj.BDAJavaScriptFile = BDAJavaScriptFile
   		s obj.ClassName= $LISTGET($G(^TMPMENU("User.BDPExecutables",code)),9)          
   		s obj.PropertyName=$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),10)
   		s sc=obj.%Save()
   		d obj.%Close()
		W "新增功能大表:"_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),4)_","_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),3),!
     	s parref = obj.%Id()
   		
		//User.BDPExtExecItem
		s childCode = 0,flag1=0
		for {
			s childCode = $o(^TMPMENU("User.BDPExtExecItem",code,childCode)) q:childCode=""
			s childCode1= ..trim(childCode)   ///去掉末尾空格
			s flag1=$d(^User.BDPExtExecItemI("CodeIndex"," "_$ZCONVERT(childCode1,"U"),parref))
			i flag1=10 continue
			
			s obj1=##class(User.BDPExtExecItem).%New(parref)
  
			d obj1.ParRefSetObjectId(parref)
   			s obj1.Code = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20)
   			s obj1.Name =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37)
   			s obj1.AllowBlank =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),18)
  			s obj1.AutoShow = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),19)
   			s obj1.Editable =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),22)
   			s obj1.Handler = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),23)
   			s obj1.Hidden = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),24)
   			s obj1.HiddenName = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),25)
   			s obj1.IconCls = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),26)
   			s obj1.ReadOnly = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),27)
   			s obj1.Regex = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),28)
   			s obj1.RegexText = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),29)
   			s obj1.ToolTip =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),30)
   			s obj1.ToolTipType =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),31)
   			s obj1.Type = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),32)
   			s obj1.XType =$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),34)
   			s obj1.Validator = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),33)
   			s obj1.ValueGet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),35)
   			s obj1.ValueSet = $LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),36)
  			s sc1=obj1.%Save()
   			d obj1.%Close()	
   			w "新增功能元素:"_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),4)_","_$LISTGET($G(^TMPMENU("User.BDPExecutables",code)),3)_","_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),20)_","_$LISTGET($G(^TMPMENU("User.BDPExtExecItem",code,childCode)),37),!
   			
		}
		w !
	}
	s code="",n=1,flag2=0
	//User.BDPMenu
	for {
		s code=$o(^TMPMENU("User.BDPMenu",n,0)) q:code=""
		s m=n
		s n=n+1
		s code1= ..trim(code)   ///去掉末尾空格
		s flag2=$d(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(code1,"U")))
		i flag2=10 continue
		s LinkFuntionDR=$o(^TMPMENU("User.BDPMenu",m,code,0))
		s:LinkFuntionDR'="" LinkFuntionDRID=$o(^User.BDPExecutablesI("CodeIndex"," "_$ZCONVERT(LinkFuntionDR,"U"),0))
		s:LinkFuntionDR="" LinkFuntionDRID="",LinkFuntionDR=0
		s ParentMenuDr=$o(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,0))
		s ParentMenuDr1= ..trim(ParentMenuDr)
		s:ParentMenuDr'="" ParentMenuDrID=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$ZCONVERT(ParentMenuDr1,"U"),0))
		s:ParentMenuDr="" ParentMenuDrID="",ParentMenuDr=0
		//////有些是先建子菜单，再建父菜单，再把子菜单指向父菜单的，要等保存完所有菜单后再处理这些
		if ((ParentMenuDr'="")&(ParentMenuDrID="")) s ^BDPMEMUGOFPAR(ParentMenuDr,code)=""
			
		s mobj=##class(User.BDPMenu).%New()
		s mobj.Code = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),2)
   		s mobj.Caption = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),3)
   		d:LinkFuntionDRID'="" mobj.LinkFuntionDRSetObjectId(LinkFuntionDRID)
   		d:LinkFuntionDRID="" mobj.LinkFuntionDRSetObjectId("")
   		s mobj.LinkUrl =$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),5)
   		s mobj.Image =$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),6)
   		s mobj.Method = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),7)
   		s mobj.Sequence = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),8)
   		s mobj.ShortcutKey =$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),9)
   		s mobj.ShowInNewWindow = $LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),10)
   		d:ParentMenuDrID'="" mobj.ParentMenuDrSetObjectId(ParentMenuDrID)
   		d:ParentMenuDrID="" mobj.ParentMenuDrSetObjectId("")
   		s mobj.UpdateDate = +$p($h,",",1)
   		s mobj.UpdateTime = +$p($h,",",2)
   		//d mobj.UpdateUserSetObjectId($Get(%session.Data("LOGON.USERID")))
   		s mobj.ValueExpression =$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),15)
   		s mobj.CompName=$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),17)
   		s mobj.ActiveFlag=$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),16)
   		s sc=mobj.%Save()
   		w "新增菜单:"_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),2)_","_$LISTGET($G(^TMPMENU("User.BDPMenu",m,code,LinkFuntionDR,ParentMenuDr)),3),!
   		d mobj.%Close()
	}
	
	
	s parcode=""
	for
	{		
		s parcode=$o(^BDPMEMUGOFPAR(parcode)) q:parcode=""
		s parcode1=..trim(parcode)
		s parid= $o(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(parcode1,"U"),0))
		continue:parid=""
		s childcode=0
		for 
		{
			s childcode=$o(^BDPMEMUGOFPAR(parcode,childcode)) q:childcode=""
			S childcode1=..trim(childcode)  ////code末尾为多个空格，但是保存后的索引里末尾不带空格，开头可以带空格
			s childid=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt(childcode1,"U"),0))
			Q:childid=""
			s oobj=##class(User.BDPMenu).%OpenId(childid)
			d oobj.ParentMenuDrSetObjectId(parid)
  			s oobj.UpdateDate = +$p($h,",",1)
			s oobj.UpdateTime = +$p($h,",",2)
			d oobj.UpdateUserSetObjectId($g(%session.Data("LOGON.USERID")))
			///S oobj.UpdateUser="1"
			ts
			s sc=oobj.%Save()
			d oobj.%Close()	
			If $$$ISOK(sc)
			{	
				Tcommit
				K ^BDPMEMUGOFPAR(parcode,childcode)
			}
			else
			{
				Trollback
				S ^TMPPAR(childcode)=parcode
			}
		}
	}
	
	
	
	
	q "导入完成"
}

/// 导出基础数据平台的global
/// d ##class(web.DHCBL.BDP.BDPMenuImport).ExportBDPGlobal()
ClassMethod ExportBDPGlobal()
{
	k CList
	k myIdx
	
	//BDPSystemData.gof
	/*s CList($i(CList))= "User.BDPConfigD.GBL" 
	s CList($i(CList))= "User.BDPConfigI.GBL" 
	s CList($i(CList))= "User.BDPMenuTableD.GBL"
	s CList($i(CList))= "User.BDPMenuTableI.GBL"
	s CList($i(CList))= "User.BDPTableFieldI.GBL"
	s CList($i(CList))= "User.BDPTableListC.GBL"
	s CList($i(CList))= "User.BDPTableListD.GBL" 
	s CList($i(CList))= "User.BDPTableListI.GBL"
	s CList($i(CList))= "User.BDPIconManageD.GBL" 
	s CList($i(CList))= "User.BDPIconManageI.GBL"*/
	
	//Menu.gof
	s CList($i(CList))= "User.BDPExecutablesC.GBL" 
	s CList($i(CList))= "User.BDPExecutablesD.GBL" 
	s CList($i(CList))= "User.BDPExecutablesI.GBL" 
	s CList($i(CList))= "User.BDPExtExecItemI.GBL" 
	s CList($i(CList))= "User.BDPMenuD.GBL" 
	s CList($i(CList))= "User.BDPMenuI.GBL" 
	
	//BDPDataIMEX.gof：导入导出管理的global 包含
	/*s CList($i(CList))= "User.BDPEILinkD.GBL"   
	s CList($i(CList))= "User.BDPEILinkI.GBL"  
	s CList($i(CList))= "User.BDPEXConfigC.GBL"  
	s CList($i(CList))= "User.BDPEXConfigD.GBL"  
	s CList($i(CList))= "User.BDPEXConfigI.GBL"  
	s CList($i(CList))= "User.BDPEXFieldConfigI.GBL"  
	s CList($i(CList))= "User.BDPIMConfigC.GBL"  
	s CList($i(CList))= "User.BDPIMConfigD.GBL"  
	s CList($i(CList))= "User.BDPIMConfigI.GBL"  
	s CList($i(CList))= "User.BDPIMFieldConfigI.GBL" 
    s CList($i(CList))= "User.BDPEIMenuD.GBL"  
	s CList($i(CList))= "User.BDPEIMenuI.GBL" */
	
    //1.BDPDATADOMAIN.gof:国家标准数据元值域的global 包含
    //s CList($i(CList))= "BDPDATADOMAIN.GBL"      

    //2.BDPDOMAINTYPE.gof：国家标准编码类别对照的global 包含 
    //s CList($i(CList))= "BDPDOMAINTYPE.GBL" 
    

    
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	//d $SYSTEM.OBJ.Export(items, "D:\BDPSystemData.gof", "", .log)
	d $SYSTEM.OBJ.Export(items, "D:\Menu.gof", "", .log)
	//d $SYSTEM.OBJ.Export(items, "D:\BDPDataIMEX.gof", "", .log)
	//d $SYSTEM.OBJ.Export(items, "D:\BDPDATADOMAIN.gof:", "", .log)
	//d $SYSTEM.OBJ.Export(items, "D:\BDPDOMAINTYPE.gof", "", .log)
}

}

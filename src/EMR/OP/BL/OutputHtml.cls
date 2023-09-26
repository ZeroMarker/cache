/// 名称:	EMR.OP.BL.OutputHtml
/// 描述:	动态输出HTML代码
/// 编写者：yejian
/// 编写日期: 2022-9-6
/// 产品组：电子病历产品组
Class EMR.OP.BL.OutputHtml Extends %RegisteredObject
{

/// 协和认证ad帐号
ClassMethod XieHeCertification()
{
		
	if "XieHe"=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName")
 	{
	 	w "<script type='text/javascript' src='../scripts/epr/js/DHCAdAuthInterface.js'>",!
	 	w "</script>",!
 	}
}

ClassMethod OutPutJSRefHtml(CTLocID As %String)
{
	s flag=##Class(CA.DigitalSignatureService).GetCAServiceStatus(CTLocID)
	if ("0"'=flag)
	{
		d ##Class(CA.DigitalSignatureService).OutPutSecXCommon()
    	//w "<script type='text/javascript' src='../scripts/emr/js/ca.keysign.js' charset='utf-8' >",!
    	//w "</script>",!
	}
}

/// d ##Class(EMRservice.OutputHtml).OutPutopkeysign("BJXHYY")
ClassMethod OutPutopkeysign(HospitalName As %String = "", pageType As %String = "")
{
	s version = ##Class(EMR.OP.BL.CAService).CAVersion()
	if ("2"=version) {
		if ("HISUI"=pageType) {
			w "<script type='text/javascript' src='../scripts/emr/js/opdoc.keysign_mobile.js'>",!
			w "</script>",!
		}
		elseif ("BS"=pageType) {
			w "<script type='text/javascript' src='../scripts/emr/js/bs.op.keysign_mobile.js'>",!
			w "</script>",!	
		}
		else {
			w "<script type='text/javascript' src='../scripts/emr/js/op.keysign_mobile.js'>",!
			w "</script>",!	
		}
	}
	else {
		if ("HISUI"=pageType) {
			w "<script type='text/javascript' src='../scripts/emr/js/opdoc.keysign.js'>",!
			w "</script>",!
		}
		elseif ("BS"=pageType) {
			w "<script type='text/javascript' src='../scripts/emr/js/bs.op.keysign.js'>",!
			w "</script>",!	
		}
		else {
			w "<script type='text/javascript' src='../scripts/emr/js/op.keysign.js'>",!
			w "</script>",!	
		}
    }
	/*if ("BJXHYY"=HospitalName) {
		d ..OnUsbChangedReadonly()
	}*/
}

ClassMethod OutputJsForModelDialg(key As %String)
{
}

// 协和使用

/*ClassMethod OnUsbChangedReadonly()
{
		
  	w " <script language='javascript'>",!
   	w " OnKeyChanged = function () ",!
   	w " {",!
	w " 	if (!GetList_pnp()) { readonly = 1; } ",!
	w " 	else { readonly = 0; } ",!
	w " 	setEditorReadonly();",!
   	w " }",!
    w " </script>",!
}*/
ClassMethod OnUsbChangedReadonly()
{
	w " <script type=""text/javascript"">",!
	w "    if (!getList_pnp()) ",!
	w "       { envVar.readonly = true; ",!
	w "          alert('当前未插key，请插入key后进行操作！');} ",! 
	w " </script>",!
  	w " <script for='XTXAPP' event='OnUsbkeyChange' language='javascript'>",!
   	w "     function OnUsbkeyChange() ",!
   	w "     {",!
	w "        if (!getList_pnp())  ",!
	w "             { envVar.readonly = true; ",!
	w "               alert('当前未插key，请插入key后进行操作！');} ",!   	
	w "        else { envVar.readonly = false; } ",!
	w "        if (typeof emrEditor.setEditorReadonly == 'function') emrEditor.setEditorReadonly();",!
   	w "     }",!
   	w "     OnUsbkeyChange();",!
   	w " </script>",!
}

// epr.frames.csp 引用

ClassMethod OnUsbChanged(CTLocID As %String)
{
	s flag=##Class(CA.DigitalSignatureService).GetCAServiceStatus(CTLocID)
	if ("0"'=flag)
	{
	
	w " <script language='javascript'>",!
	w " var OnKeyChanged;",!
    w " </script>",!	
	
	w " <script for='XTXAPP' event='OnUsbkeyChange' language='javascript'>",!
   	w " function OnUsbkeyChange() ",!
   	w " {",!
	w " 	try { OnKeyChanged(); } catch(e) {}",!
   	w " }",!
	w " ",!
	w " OnUsbkeyChange();",!
    w " </script>",!
    
	}
}

}

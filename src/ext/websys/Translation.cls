/// 名称: ext.websys.Translation
/// 描述: ExtJs开发的csp页面的多语言支持
/// 编写者：吴群科
/// 编写日期: 2012-10-23
Class ext.websys.Translation Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter PAGE = "PAGE";

Parameter MENU = "MENU";

/// Creator：     吴群科
/// CreatDate：   2012-10-23
/// Description:  输出ExtJs 语言包
/// Table：       SS_Lanuage
/// Input：       
/// ret：      	  ExtJs 中，各语言对应的js文件名
/// set language=##class(ext.websys.Translation).ExtLanuageFile()
/// SS_Lanuage 中定义的语言如下
/// 1	EN	English
/// 3	GR	Greek
/// 20	CH	Chinese
/// 56	TH	Thai
/// 59	SP	Spanish
/// 60	IT	Italian
/// 61	FR	French
/// 62	GR	German
/// 63	PT	Portuguese
/// 64	RU	Russian
/// 65	UA	Ukrainian
/// 66	MA	Malaisian
/// 100	AR	Arabic
ClassMethod ExtLanuageFile()
{
	set lanuage="ext-lang-zh_CN.js"          //默认情况，读取中文
	set lan=+$g(%session.Data("LOGON.LANGID"))
	if (lan=1){set lanuage="ext-lang-en.js"}               //英文
	elseif (lan=3){set lanuage="ext-lang-gr.js"}                         //Greek ext-lang-gr.js
	elseif (lan=20){set lanuage="ext-lang-zh_CN.js"}                     //Chinese ext-lang-zh_CN.js
	elseif (lan=56){set lanuage="ext-lang-th.js"}                        //Thai ext-lang-th.js
	elseif (lan=59){}                         //Spanish 
	elseif (lan=60){set lanuage="ext-lang-it.js"}                         //Italian ext-lang-it.js
	elseif (lan=61){set lanuage="ext-lang-fr.js"}                         //French ext-lang-fr.js
	elseif (lan=62){set lanuage="ext-lang-gr.js"}                         //German ext-lang-gr.js
	elseif (lan=63){set lanuage="ext-lang-pt.js"}                         //Portuguese ext-lang-pt.js
	elseif (lan=64){set lanuage="ext-lang-ru.js"}                         //Russian ext-lang-ru.js
	elseif (lan=65){set lanuage="ext-lang-ukr.js"}                         //Ukrainian ext-lang-ukr.js
	elseif (lan=66){}                         //Malaisian 
	elseif (lan=100){}                         //Arabic
	quit lanuage
}

/// Creator：     吴群科
/// CreatDate：   2012-10-23
/// Description:  向csp页面输出翻译相关信息
/// d ##class(ext.websys.Translation).WriteTranslations()
ClassMethod WriteTranslations()
{
	
	Write "<SCRIPT language='javascript' type='text/javascript'>"	
	Write !,"    function $g(item){"
	Write !,"    	try {"
	Write !,"    		eval(""returnValue=trans['""+item+""'];"");"
	Write !,"    			if (returnValue==undefined){"
	Write !,"    				eval(""trans['""+item+""']='';"");"
	Write !,"    				returnValue=item;"
	Write !,"    			}"
	Write !,"    			if (returnValue==''){returnValue=item;}"
	Write !,"    	} catch (e) {"
	Write !,"    		eval(""trans['""+item+""']='';"");"
	Write !,"    		returnValue=item;"
	Write !,"    	}"
	Write !,"    	return returnValue;"
	Write !,"    }"	
	Write !,"    var page='"_%request.PageName_"';"
	Write !,"    var trans=new Object();"
	d ..WritePageTrans()
	d ..WriteKeyPress()
	Write !,"<"_"/SCRIPT>"
}

/// Creator：     吴群科
/// CreatDate：   2012-10-23
/// Description:  输出按键事件
/// 如果安全组中定义：允许使用界面编辑器(SSGRP_AllowWebLayoutManager="Y")，则可通过快捷键Ctrl+T，显示翻译页面 
ClassMethod WriteKeyPress()
{
	new (%session,%request)
	
	//Write !,"    window.onload=function(){alert('load');document.body.onkeydown=ExtTool.noNumbers};"
	
	set groupId=$g(%session.Data("LOGON.GROUPID"),0)
	quit:(groupId="")||(groupId=0) 0
	quit:'$d(^SSU("SSGRP",groupId)) 0
	set AllowWebLayoutManager=$p($g(^SSU("SSGRP",groupId)),"^",50)
	quit:AllowWebLayoutManager'="Y" 0
	Write !,"    var saveMethods='"_##class(websys.Page).Encrypt($lb("ext.websys.Translation.SavePageTranslation"))_"';"
	Write !,"    function ShowTranslation(e){"
	Write !,"    	if ((""undefined""!==typeof $) && (""undefined""!==typeof $.hisui)) return ;"
	Write !,"    	//e.stopPropagation();e.stopEvent();"
	Write !,"    	if (e.altKey && Ext.EventObject.T==e.getKey()){   //  Alt + T" 
	Write !,"    		var win = new Ext.Window({"
	Write !,"    	    title: 'Translate',"
	Write !,"    	    layout : 'fit',"
	Write !,"    	    width : 360,"
	Write !,"    	    height : 500,"
	Write !,"    	    items: new Ext.grid.PropertyGrid({"
	Write !,"    	    	id:'transGridProperty',"
	Write !,"    		    //autoHeight: true,"
	Write !,"    		    viewConfig: {forceFit: true},"
	Write !,"    		    source: trans,"
	Write !,"    		    bbar : ['->','-',{"
	Write !,"    	            text: 'OK',"
	Write !,"    	            handler: function(){"
	Write !,"    	            	s=Ext.getCmp('transGridProperty').source;"
	Write !,"    	            	for (p in s){var retval=cspHttpServerMethod(saveMethods,page,p,s[p]);}"
	Write !,"    	            	win.close();"
	Write !,"    	            	location.reload();"
	Write !,"    	            }"
	Write !,"    	          },'-',{"
	Write !,"    	            text: 'Cancel',"
	Write !,"    	            handler: function(){win.close();}"
	Write !,"    	          },'-']"
	Write !,"    			})"
	Write !,"    		});"
	Write !,"    		win.show();"
	Write !,"    	}"
	Write !,"    	return false;"
	Write !,"    }"
	Write !,"    //Ext.onReady(function () {document.body.onkeydown=ShowTranslation})"
	Write !,"    Ext.onReady(function () {try{Ext.EventManager.on(Ext.getBody(), 'keydown',ShowTranslation);}catch(e){}})"
	
	quit 1
}

/// Creator：     吴群科
/// CreatDate：   2012-10-23
/// Description:  获取页面的翻译信息
/// Table：       SS_Lanuage
/// Input：       
/// ret：      	  ExtJs 中，各语言对应的js文件名
/// ^websys.TranslationD("PAGE",langid,page,item)=val
ClassMethod WritePageTrans()
{
	new (%session,%request,t)
	set langid=+$g(%session.Data("LOGON.LANGID"))
	set page=%request.PageName
	quit:(langid=0)||(page="") 0
	set item=""
	//set ^websys.TranslationD("PAGE",langid,page,item)=val
	set item=""
	for {
		set item=$o(^websys.TranslationD("PAGE",langid,page,item))
		quit:item=""
		Write !,"    trans["""_item_"""]="_"'"_$zcvt($g(^websys.TranslationD("PAGE",langid,page,item)),"O","JS")_"';"
	}
	quit 1
}

/// Creator：     吴群科
/// CreatDate：   2012-10-23
/// Description:  存储 页面的翻译信息
/// Table：       SS_Lanuage
/// Input：       
/// ret：      	  ExtJs 中，各语言对应的js文件名
/// ^websys.TranslationD("PAGE",langid,page,item)=val
ClassMethod SavePageTranslation(page, item, val)
{
	new (page,item,val,%session,%request)
	set langid=+$g(%session.Data("LOGON.LANGID"))
	quit:(langid=0)||(page="")||(item="") 0
	set ^websys.TranslationD("PAGE",langid,page,item)=val
	quit 1
}

}

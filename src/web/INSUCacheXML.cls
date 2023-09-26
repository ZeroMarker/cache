Class web.INSUCacheXML Extends %String
{

Parameter EscapeChar As COSEXPRESSION = "$LB($LB(""<"",""&lt;""),$LB("">"",""&gt;""),$LB(""&"",""&amp;""),$LB(""'"",""&apos;""),$LB("""""""",""&quot;""))";

Parameter UnEscapeChar As COSEXPRESSION = "$LB(""&lt;"",""&gt;"",""&amp;"",""&apos;"",""&quot;"")";

Parameter JSonSlice [ Final, Internal ] = 1;

Parameter JSonInString [ Final, Internal ] = 2;

Parameter JSonInArray [ Final, Internal ] = 3;

Parameter JSonInObject [ Final, Internal ] = 4;

/// 把CACHE的数组转为JSON字符串.  
/// w ##class(web.INSUCacheXML).ArrToXML(Array)
ClassMethod ArrToXML(data As %DataType, dataParNode As %String) As %String
{
	;s test=##class(%ArrayOfDataTypes).%New()

  if $IsObject(data) {  
    s key=""   
    s typeData=data.%ClassName()
    if typeData="%ArrayOfDataTypes" {
      //type object
      s key=""
      s cad=""
      F {
        s pData=data.GetNext(.key)
        q:key=""
        s tmpkey=key
        s tmpdataParNode=""
        if $IsObject(pData) { 
        	s tmptypeData=pData.%ClassName()
        	if tmptypeData["List" {
	        	s tmpkey=""
	        	s tmpdataParNode=key
	        }
        }
        s value=..ArrToXML(pData,tmpdataParNode)
        s:tmpkey'="" cad=cad_"<"_tmpkey_">"_value_"</"_tmpkey_">"
        s:tmpkey="" cad=cad_value
      } 
      q cad
    }
    elseif typeData="%ListOfDataTypes" {
      //type array     
      s cad=""
      f i=1:1:data.Count() {
        s tmp=..ArrToXML(data.GetAt(i),"")
        ;s cad=$S(i>1:cad_",",1:"")_tmp
        s cad=cad_"<"_dataParNode_">"_tmp_"</"_dataParNode_">"
      }
      q cad
    }
    //ZMC Add ListofObj 20151022
    elseif typeData["ListOfObj" {
      //type list      
      s cad=""
      f i=1:1:data.Count() {
        s tmp=..Serialize(data.GetAt(i))
        s cad=cad_"<"_dataParNode_">"_tmp_"</"_dataParNode_">"
      }

      q cad
    }
	else {
		
		//maybe is OBJ,ZMC 20190425
		s cad=..Serialize(data.GetAt(i))
		q cad
	}
  }
  elseif $ISVALIDNUM(data) {
    // type number
    s:$p(data,".",1)="" data=0_data
    q $s(($e(data,1,1)="0")&&($e(data,1,2)'="0."):..Escape(data),1:data)
    q data
  }
  elseif (($FIND(data,"."))&&(($e(data,1)'="{")&&($e(data,1)'="["))) {
    q:data="" ""
    q ..Escape(data)
  }
  elseif $Case(data, "true":1, "false":1, :0) {
	  q data
  }
  else {
    //type string
    q:data="" ""
    q ..Escape(data)
  }
}

/// 判断是否转码(只判断第一个\是否转码). 
ClassMethod isEscaped(str As %String, c As %String) As %Boolean [ Internal ]
{
  s pos=$F(str,c)
  q ($L($E(str,1,pos))-$L($TR($E(str,1,pos),"&","")))#2=1
}

/// 给字符串转码   
ClassMethod Escape(str As %String) As %String [ Internal ]
{
  for tI=1:1:$LL(..#EscapeChar) d
  .s tCharPair=$LG(..#EscapeChar,tI)
  .s str=$REPLACE(str,$LG(tCharPair,1),$LG(tCharPair,2))  
  Quit str
}

ClassMethod Unescape(str As %String) As %String [ Internal ]
{
  For tI=1:1:$Length(str) d
  .Set tChar=$ListFind(..#UnEscapeChar,$E(str,tI,tI+1))
  .if (tChar>0) d
  ..Set $E(str,tI,tI+1)=$LG($LG(..#EscapeChar,tChar),1)
  Quit str
}

// 对象生成XML

// w ##class(web.INSUCacheXML).Serialize(testobj)

ClassMethod Serialize(objClass, root As %String = "", Charset As %String = "") As %String
{
	s RtnXML=""
	q:$IsObject(objClass)=0 RtnXML
	set writer=##class(%XML.Writer).%New()
	;set:root="" root="root"
	set:Charset="" writer.Charset="UTF-8"

	if (objClass.%IsA("%Library.Persistent")||(objClass.%IsA("%RegisteredObject"))){
		s className=objClass.%ClassName()
		s pkgName=objClass.%PackageName()
		set:root="" root=className
		s key=""
		s:$$$defClassDefined(className) ClassName=className
		s:$$$defClassDefined(pkgName_"."_className) ClassName=pkgName_"."_className
		set sc=writer.OutputToString()
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit RtnXML
		s sc=writer.RootElement(root)
		
		f {
			s key=$$$defMemberNext(ClassName,$$$cCLASSproperty,key)
			q:key=""
			i $e(key,1)="%"{
				continue
			}
			s private=$$$comMemberKeyGet(ClassName,$$$cCLASSproperty,key,35)
			if private=1{
				continue
			}
			s (tmptype,subclass)=""
			i $$$defMemberKeyDefined(ClassName,$$$cCLASSproperty,key,27) {
				s tmptype=$$$defMemberKeyGet(ClassName,$$$cCLASSproperty,key,27)
				s subclass=$$$defMemberKeyGet(ClassName,$$$cCLASSproperty,key,5)
				;s subar=myDecodedArray.GetAt(key)
				s tmpsubclassobj=""
				s subkey=key
				q:$$ALPHAUP^SSUTIL4(tmptype)'="LIST"
				s tmpvn="##class("_subclass_").%New()"
				Set tmpsubclassobj=$$XECUTEN^INSUFUN(tmpvn)
				//XECUTE ("Set tmpsubclassobj=##class("_subclass_").%New()")
				s sc=writer.RootElement(subkey)
				f{
					s slkey=""
					s slkey=$$$defMemberNext(subclass,$$$cCLASSproperty,slkey)
					q:slkey=""
					i $e(slkey,1)="%"{
						continue
					}
					s private=$$$comMemberKeyGet(subclass,$$$cCLASSproperty,slkey,35)
					if private=1{
						continue
					}
					set sc=writer.Object(tmpsubclassobj,slkey)
				}
				s sc=writer.EndRootElement()

				//s:$IsObject(tmpsubclassobjlist) $PROPERTY(rtnobj,subkey)=tmpsubclassobjlist
			}else{
				//s $PROPERTY(rtnobj,key)=myDecodedArray.GetAt(key)
				//set sc=writer.Object(objClass,key)
			}
		}
		
		set sc=writer.Object(objClass,"root")
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit RtnXML
		s sc=writer.EndRootElement()
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit RtnXML
		s RtnXML=writer.GetXMLString()
	}
	q RtnXML
}

/// objClass:对象的实例
/// mNode:XML的根节点
/// XML：XML字符串
/// s testobj=##class(web.INSUTest0).%New()
/// s xml="<root><Person><CacheID>4</CacheID><Name>56</Name><DOB>1964-11-14</DOB><Address><test111>Hialeah</test111><test222>94999</test222></Address><Doctors><Doctor><test11>Vanzetti,Debra B.</test11></Doctor></Doctors></Person></root>"
/// s xml2="<root><Person><CacheID>4</CacheID><Name>56</Name><DOB>1964-11-14</DOB><Address test111=""Hialeah"" test222=""94999"" /><Doctors><Doctor test11=""Vanzetti,Debra B."" /></Doctors></Person></root>"
/// XML串转换为对象
/// d ##class(web.INSUCacheXML).Deserialize(.testobj,"Person",xml)
/// 20221117 DingSH 增加补充说明
/// 1:持久类或注册类 需要继承 %XML.Adaptor,否走无法解析
/// 2:举例子：<root><Name>张三</Name><Sex></Sex></root>  
///          如果设置  XMLIGNORENULL = 0 ,默认值  那么obj.Sex=$c(0) ,如果是持久类保存到表中则破坏global存值：
///          如果设置  XMLIGNORENULL = 1          那么obj.Sex=""
ClassMethod Deserialize(objClass, mNode As %String = "", inXML As %String = "") As %RegisteredObject
{
	q:$IsObject(objClass)=0 objClass
	s rtnobj=objClass
	if (objClass.%IsA("%Library.Persistent")||(objClass.%IsA("%RegisteredObject"))){
		s className=objClass.%ClassName()
		s pkgName=objClass.%PackageName()
		s:$$$defClassDefined(className) ClassName=className
		s:$$$defClassDefined(pkgName_"."_className) ClassName=pkgName_"."_className
		s reader = ##class(%XML.Reader).%New()
		s sc=reader.OpenString(inXML)
		s:mNode="" mNode=objClass.XMLNAME
		Do reader.Correlate(mNode,ClassName)
		While (reader.Next(.mObj,.sc)) {
			
			If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
			if ($ISOBJECT(mObj)){
				s objClass=mObj 
				d mObj.%Close() 
			}
		}
	}
	q objClass
}

/// d ##class(web.INSUCacheXML).test()
ClassMethod test() As %RegisteredObject [ ProcedureBlock = 1 ]
{
	s testobj=##class(web.INSUTest0).%New()
	s xml2="<root><Person><CacheID>4</CacheID><Name>56</Name><DOB>1964-11-14</DOB><Address test111=""Hialeah"" test222=""94999"" /><Doctors><Doctor test11=""Vanzetti,Debra B."" /></Doctors></Person></root>"
	s test=##class(web.INSUCacheXML).Deserialize(.testobj,xml2)
	w "w tmp.Address.test111:",tmp.Address.test111,!
	q test
}

}

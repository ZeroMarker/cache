Class web.DHCMGPageData Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s node = %request.Get("node")
	//w "[{text:'fold2',id:'fold2',leaf:false,children:[{text:'itm21',id:'itm21',leaf:false,children:[{text:'ver211',id:'ver211',leaf:true}]},{text:'itm22',id:'itm22',leaf:false,children:[{text:'ver221',id:'ver221',leaf:true}]}]}]"
    w ##class(web.DHCNUREMR).WinTeste("fold1")   
   // s ^TMP("fold2")=a
    Quit $$$OK
	s aaa="aaa",bbb="bbb",flag="false"
	w "["
    w "{text:'"_aaa_"'" 
    w ",id:'"_bbb_"'"
    w ",children:[{text:'abf',leaf:true},{text:'abf',leaf:true}]"
    w ",leaf:"_flag_"}"
    w ","
    w "{text:'"_"a"_"'" 
    w ",id:'"_"b"_"'"
    w ",leaf:"_"true"_"}"
    
	w "]" 
    Quit $$$OK
}

}

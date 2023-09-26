Class web.DHCLabController Extends %CSP.Page [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	/*
	&html<<html>
<head>
</head>
<body>>
	; To do...
	&html<</body>
</html>>
*/
	//&html<>
	//S %response.ServerSideRedirect = "DHCLabError.csp"
 	//S %response.Redirect = "DHCLabError.csp"
 
 	// Description:
 	//		此CSP完成Action控制器功能，负责Action流控制
 	// Creator:    	wwh
	// CreatDate:  	20100919
 	// LastUpdateDate:	20100919
 	// Version: 		V1.0.0.1
	// Remark:			如果不能创建Action,则返回的客户端的数据为JSON格式的，如果执行成功则返回的数据由Action决定。
 	//					存在的问题：客户端采用Ext为UI,很多数据交互为AJAX异步交互，服务器端页面跳转将失效，错误显示
 	//					方式有待商议。另外，在数据的处理中，尚未对实体类数据的动态绑定与获取进行建模
 	//S %request.CharSet="UTF-8" 
 	//S %response.CharSet="UTF-8" 
 	//D %request.ConvertCharSet() 
 	//S %response.HeaderCharSet="UTF-8" 
   
    
 	//获取actionID,并转换为大写
 	S actionID=$ZCVT($g(%request.Data("action",1)),"U")
 	//JSON格式错误信息，针对EXT
 	S errMsg="{'success':"_"false"_",'info':'Action is Null!'}"
 	W:'$l(actionID) errMsg
 	Q:'$l(actionID) 
 	//根据actionID获取一个ActionHandler的实例
 	S actionHandler=##class(web.ActionFactory).GetActionHandler(actionID)
 	S errMsg="{'success':"_"false"_",'info':'Action is Not Exist!'}"
    W:'$l(actionHandler) errMsg
 	Q:'$l(actionHandler)
 	W:$$$NULLOREF=$g(actionHandler) errMsg
 	Q:$$$NULLOREF=$g(actionHandler) 

 	//调用通用接口,返回的数据如果需要为JSON格式需要在Execute中转换，而不放在此处转换
 	S ret=actionHandler.DoAction(%request,%response,%session)
 
 	//释放对象
 	D actionHandler.%Close()
	Quit $$$OK
}

}

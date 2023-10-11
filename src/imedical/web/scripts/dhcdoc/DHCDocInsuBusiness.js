/*
**	Creater：
	CreateDate：2022-09-13
	Filename:DHCDocInsuBusiness.js
	Description：国家医保智能审核
*/
var InsuBusinessConfigObj = {
	EnableFlag: "N" //是否启用
}

var InsuBusiness=(function(){
	function GetEnableFlag(){
		var EnableFlag=$cm({
			ClassName: "web.DHCDocConfig",
			MethodName: "GetConfigNode",
			Node : "EnableInsuBusiness",
			HospId: session['LOGON.HOSPID']
		},false);
		InsuBusinessConfigObj.EnableFlag=(EnableFlag=="1")?"Y":"N";
	}
	function YBJGBusinessCheck(Type,argObj,callBackFun){
		try{
			//alert("YBJGBusinessCheck,"+InsuBusinessConfigObj.EnableFlag)
			//console.trace()
			if(InsuBusinessConfigObj.EnableFlag!="Y"){
				return true;
			}
			/*
				事前场景：1:门诊挂号,2:门诊收费登记,3:住院登记,4:住院收费登记,5:住院执行医嘱
				事中场景：6	门诊结算;7	门诊预结算;8	住院结算;9	住院预结算;10	购药划卡		
			*/
			var PAAdmType=argObj.PAAdmType;
			var EpisodeID=argObj.EpisodeID;
			var OrderItemStr=argObj.OrderItemStr;
			if(typeof OrderItemStr == "undefined"){
				OrderItemStr="";
			}
			var SceneType=""
			if(Type=="3101"){    ///事前提醒
				SceneType=PAAdmType != "I"?2:4
			}else if(Type=="3102"){  //事中警醒
				SceneType=PAAdmType != "I"?7:9 
			}
			if(SceneType=="") return false;
			$.cm({
				ClassName:'DHCDoc.Interface.YiBaoJianGuan.Business',
				MethodName:'CheckBusinessData',
				EpisodeID:EpisodeID,
				SceneType:SceneType,
				Type:Type,
				UserID:session['LOGON.USERID'],
				CTLocID:session['LOGON.CTLOCID'],
				OrdStr:OrderItemStr,
				dataType:'text'
			},function(ret){
				var rtn=ret.split("^")[0]
				var msg=ret.split('^')[1]
				if(rtn=='0'){
					if(msg!=""){
					    console.log("msg:"+msg)
					    if(msg!="[]"){
				    		websys_showModal({
								url:"dhcdoc.insusupervison.advice.csp", //?advicestr=" + encodeURIComponent(msg),
								advicestr:msg,
								title:'医保监管平台提醒',
								width:'78%',height:'50%'
							});
						}
					}
				}else{
					if(msg!=""){
						$.messager.alert("医保监管平台提醒",msg, 'info');
					}
				}
			});
		}catch(e){$.messager.alert("调用监管平台提醒", e.message, 'error');}	
	}
	
	return {
		"YBJGBusinessCheck":YBJGBusinessCheck,
		"GetEnableFlag":GetEnableFlag
	}
})()
InsuBusiness.GetEnableFlag();
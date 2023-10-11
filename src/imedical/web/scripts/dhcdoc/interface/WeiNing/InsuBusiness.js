/*
Creater:	jm
CreateDate：2023-02-09
Description:卫宁国家医保智能审核统一封装JS
*********************************************
* 1.启用此接口时需核对修改【DHCDoc.Interface.YiBaoJianGuan.LocalData.cls】本地参数变量
* 2.检查程序主入口【DHCDoc.Interface.YiBaoJianGuan.Business.cls】依赖的医保组、临床组接口是否存在并可正常调用
	<医保组>
		##class(%ResultSet).RunQuery("web.DHCINSUPort","GetTarItemInfoByOrdId")
		##class(INSU.OFFBIZ.BL.BIZ00A).InsuDocDetailedAuditService
	<临床组>
		##class(%ResultSet).RunQuery("web.DHCANAdaptor","FindOperationDTO")
* 3.查询医保数据接口:数据来源自账单,若门诊下医嘱不生成账单,需要联系计费组修改
* 4.可找一位测试的医保患者,调用以下方法看上传数据是否合规,以及是否有返回卫宁的分析数据
	w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).CheckBusinessData(EpisodeID,SceneType,Type,UserID)
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var WNInsuBusinessObj = {
		Name:"WeiNing_InsuBusiness",
		//医嘱录入
		OEOrd:{
			//初始化
			xhrRefresh:function(EpisodeID,PAAdmType) {
				InsuBusinessFuncs.YBJGBusinessCheck("3101",EpisodeID,PAAdmType);
			},
			//审核前,目前只是提示,未做控制
			BeforeUpdate:function(EpisodeID,PAAdmType,OrderItemStr,CallBackFunc) {
				//InsuBusinessFuncs.YBJGBusinessCheck("3102",EpisodeID,PAAdmType,OrderItemStr,CallBackFunc);
				CallBackFunc(true);
			},
			//审核后
			AfterUpdate:function(EpisodeID,PAAdmType) {
				InsuBusinessFuncs.YBJGBusinessCheck("3102",EpisodeID,PAAdmType);
			}
		},
		//中草药录入
		CMOEOrd:{
			//初始化
			xhrRefresh:function(EpisodeID,PAAdmType) {
				InsuBusinessFuncs.YBJGBusinessCheck("3101",EpisodeID,PAAdmType);
			},
			//审核后
			AfterUpdate:function(EpisodeID,PAAdmType) {
				InsuBusinessFuncs.YBJGBusinessCheck("3102",EpisodeID,PAAdmType);
			}
		},
		OPAdm:{
			//挂号-成功后
			AfterReg:function(EpisodeID,PAAdmType) {
				InsuBusinessFuncs.YBJGBusinessCheck("1",EpisodeID,PAAdmType);
			}
		},
		Funcs:{
			//其它业务界面的调用
			YBJGBusinessCheck:function(EpisodeID,PAAdmType) {
				InsuBusinessFuncs.YBJGBusinessCheck("3101",EpisodeID,PAAdmType);
			}
		}
	}
	Common_ControlObj.InterfaceArr.push(WNInsuBusinessObj);
	//
	var InsuBusinessFuncs={
		YBJGBusinessCheck:function (Type,EpisodeID,PAAdmType,OrderItemStr,callBackFun){
			try{
				/*
					事前场景：1:门诊挂号,2:门诊收费登记,3:住院登记,4:住院收费登记,5:住院执行医嘱
					事中场景：6:门诊结算;7:门诊预结算;	8:住院结算;9:住院预结算;  10:购药划卡		
				*/
				var SceneType="";
				if(Type=="3101"){		//事前提醒
					SceneType=PAAdmType != "I"?2:4
				}else if(Type=="3102"){	//事中警醒
					SceneType=PAAdmType != "I"?7:9 
				}else{
					SceneType=Type;
				}
				if(SceneType=="") return false;
				if(typeof OrderItemStr == "undefined"){
					OrderItemStr="";
				}
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
					var rtn=ret.split("^")[0];
					var msg=ret.split('^')[1];
					if (rtn=='0'){
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
						}else{
							$.messager.popover({
								msg:ret,
								type:'error',
								style:{
									'bottom':-document.body.scrollTop - document.documentElement.scrollTop + 10,
									'right':10
								}
							});
						}
					}
					return InsuBusinessFuncs.ReturnData(callBackFun);
				});
			}catch(e){
				$.messager.alert("调用监管平台提醒", e.message, 'error');
				return InsuBusinessFuncs.ReturnData(callBackFun);
			}	
		},
		ReturnData:function(callBackFun){
			if(typeof callBackFun=="function"){
		    	callBackFun(true);
	    	}else{
				return true;	
			}
		}
	}
})

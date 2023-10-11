/**
* CreateDate: 	2023-02-13 
* Version:		V2.0
* Creator:		nk
* 厂商： 		东华医为合理用药
* scripts/dhcdoc/interface/iMedical/HLYY.js
* Description:	封装合理用药系统方法，防止变量污染;修正该方法可以被医嘱录入和草药录入同时引用
* 重写js,按照医生站标准接口层规范编写
*
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var DHCHLYYObj = {
		Name:"iMedical_HLYY",
		//医嘱录入
		OEOrd:{
			Init:function(){
				DHCPass_Funcs.ShowAuditPopProcess();	
			},
			//审核前
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				DHCPass_Funcs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"OEOrd");
			}
		},
		//中草药录入
		CMOEOrd:{
			Init:function(){
				DHCPass_Funcs.ShowAuditPopProcess();	
			},
			//审核前
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				DHCPass_Funcs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"CMOEOrd");
			}
		},
		Funcs:{
			//相互作用(仅在点击相互作用按钮时弹出)
			XHZY:function(EpisodeID) {
				var e = window.event || e;
				if (!e) return;
				if (!e.currentTarget) return;
				if (e.currentTarget.id!="XHZY") return;
				DHCPass_Funcs.XHZY(EpisodeID);
			},
			//说明书
			YDTS:function(ARCIMRowid) {
				try{
					DHCPass_Funcs.YDTS(ARCIMRowid);
				}catch(e){
					$.messager.alert("警告","合理用药说明书异常:"+e.message,"error");
				}	
			},
			//医为审方消息通知
			ShowAuditPopProcess:function(){
				DHCPass_Funcs.ShowAuditPopProcess();	
			}
	    }
	}
	Common_ControlObj.InterfaceArr.push(DHCHLYYObj)
	//
	var DHCPass_Funcs={
		//医为审方消息通知
		ShowAuditPopProcess:function(){
			//Modify20230224 已对接审方系统
			/*
			try{
				_openShowAuditPopProcess({"userType":"Doc"});	
			}catch(e){
				
			}
			*/
		},
		BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr,HLYYLayOut){
			$.extend(GlobalObj,{
				hlyy_pdss_chkInfo:""	
			})
			new Promise(function(resolve){
				try{
					DHCPass_Funcs.DHCXHZY(EpisodeID,OrderItemStr,resolve,HLYYLayOut);
				}catch(e){
					$.messager.alert("提示", "医为合理用药自动验证通过:"+e.message, "info",function(){
						resolve(true);
					});
				}
			}).then(function(HLYYInfo){
				if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) {
					//不需要调用合理用药或者程序异常
					CallBackFunc({SuccessFlag:true,UpdateFlag:false});
					return;
				}
				GlobalObj.hlyy_pdss_chkInfo=HLYYInfo.MsgID+"&"+HLYYInfo.manLevel+"&"+HLYYInfo.passFlag+"&"+HLYYInfo.manLev;
				//通过合理用药的返回修改和强制审核操作后，判断pdssFlag的值，等于1则直接生成医嘱，等于0则不能生成医嘱
				if (HLYYInfo.passFlag=="1") {
					var UpdateOrderItemStr=DHCPass_Funcs.ResetOrderItemStr(OrderItemStr,HLYYInfo.drugUniqueStr,HLYYLayOut);
					CallBackFunc({
						SuccessFlag:true,
						UpdateFlag:true,
						OrderItemStr:UpdateOrderItemStr,
						UpdateOrderItemStr:UpdateOrderItemStr
					});
				}else if (HLYYInfo.passFlag=="0"){
					CallBackFunc({
						SuccessFlag:false,
						UpdateFlag:false
					});
				}else{
					$.messager.confirm('确认对话框',"合理用药干预系统异常!"+"<br>"+"请联系信息中心!若确认审核医嘱请点击【确定】", function(r){
						if (r) {
							//var UpdateOrderItemStr=DHCPass_Funcs.ResetOrderItemStr(OrderItemStr,HLYYInfo.drugUniqueStr,HLYYLayOut);
							CallBackFunc({
								SuccessFlag:true,
								UpdateFlag:false
								//UpdateOrderItemStr:UpdateOrderItemStr
							});
						}else{
							CallBackFunc({SuccessFlag:false,UpdateFlag:false});
						}
					});
				}
				return;
			});
		},
		//审核医嘱(合并医嘱录入/中草药录入,后台拆分数据)
		DHCXHZY:function (EpisodeID,OrderItemStr,CallBackFunc,HLYYLayOut){
			var ScreenDataObj=DHCPass_Funcs.HisScreenData(EpisodeID,OrderItemStr,HLYYLayOut);

			var PdssObj=ScreenDataObj.Patient;
			if(!PdssObj){CallBackFunc(); return "";}	
			PdssObj.ItemDis=ScreenDataObj.ScreenDiagList.Diagnoses;
			PdssObj.ItemOrder=ScreenDataObj.ScreenDrugList.OrderDrugs;
			if(PdssObj.ItemOrder=="" || PdssObj.ItemOrder.length==0){
				CallBackFunc();
				return "";
			}
			PdssObj.ItemHisOrder=ScreenDataObj.HisOrderList.OrderDrugs;
			PdssObj.ItemAyg=ScreenDataObj.ScreenAllergenList.Allergens;
			PdssObj.ItemOper=ScreenDataObj.ScreenOperationsList.Operations;
			PdssObj.UseType="Doc";
			new Promise(function(resolve){
				var DHCPdss = new PDSS({});
				DHCPdss.refresh(PdssObj, resolve, 1);  /// 调用审查接口
				if  (DHCPdss.passFlag==1) resolve(DHCPdss);
			}).then(function(PdssOption){
				if(typeof CallBackFunc == "function"){
					CallBackFunc(PdssOption);
				}
			});
		},
		//相互作用
		XHZY:function (EpisodeID){
			new Promise(function(resolve,rejected){
				GetOrderDataOnAdd(resolve);
			}).then(function(OrderItemStr){
				if (OrderItemStr=="") {
					$.messager.alert("提示","没有新开医嘱");
					return false;
				}
				var HLYYLayOut=GlobalObj.HLYYLayOut;
	    		DHCPass_Funcs.DHCXHZY(EpisodeID,OrderItemStr,"",HLYYLayOut);
			})
		},
		YDTS:function (ARCIMRowid){
			if ((typeof ARCIMRowid=="undefined")||(ARCIMRowid==null)||(ARCIMRowid=="")) {
				$.messager.alert("警告","请选择一条医嘱");  
				return;  
			}
			var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",ARCIMRowid);
			var ArcimInfoAry=ArcimInfo.split("^");
			var OrderARCIMCode=ArcimInfoAry[0];
			var OrderName=ArcimInfoAry[1];
			DHCPass_Funcs.DHCYDTS(OrderARCIMCode,OrderName);
		},
		//说明书
		DHCYDTS:function(OrderARCIMCode,OrderName){
			var IncId=""
			//linkUrl="dhcckb.wiki.csp?IncId="+IncId+"&IncCode="+OrderARCIMCode+"&IncDesc="+OrderName;
			var linkUrl="dhcckb.pdss.instruction.csp?IncId="+IncId+"&IncCode="+OrderARCIMCode+"&IncDesc="+OrderName
			websys_showModal({
				url:linkUrl,
				title:$g('药品说明书'),
				width:screen.availWidth-200,height:screen.availHeight-200
			});
		},
		HisScreenData:function (EpisodeID,OrderItemStr,HLYYLayOut){
			//用户id^科室id^院区id^系统模式(用于区分互联网医院,前台录入可为空)
			var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']+"^"+session['LOGON.GROUPID'];
			var PrescObj=$.cm({
				ClassName:"web.DHCDocHLYYDHC",
				MethodName:"GetPrescInfo",
				EpisodeID:EpisodeID,
				Action:"",
				OrderItemStr:OrderItemStr,
				HLYYLayOut:HLYYLayOut,
				ExpStr:ExpStr
			},false)
			if (PrescObj.ResultCode=="-1") {
				$.messager.alert("提示",PrescObj.ResultContent);
				return false;
			}
			if(JSON.stringify(PrescObj) == "{}"){
				return false;	
			}
			return PrescObj;
		},
		ResetOrderItemStr:function(OrderItemStr,MedHLYYInfo,HLYYLayOut){
			//将合理用药审查信息更新到医嘱串中
			if(typeof(MedHLYYInfo)!="undefined"){
				var MedHLYYNeedMatchAry=new Array();
				//药品唯一标识串  unique(药品唯一标识-安全用药生成)_"^"_arciId(医嘱项id)_"^"_seqNo(医嘱序号)_"^"_drugPassFlag(药品通过标志Y/N)
				//多条标识串由!!分割
				var MedHLYYArr=MedHLYYInfo.split("!!");
	            for (var i=0;i<MedHLYYArr.length;i++) {
	                var oneMedHLYYArr=MedHLYYArr[i].split('^');
	                var MedHLYY_unique=oneMedHLYYArr[0];
	                var MedHLYY_SeqNo=oneMedHLYYArr[2];
	                var oneMedHLYY=oneMedHLYYArr.join(String.fromCharCode(3)); //草药用的$c(2)
	                MedHLYYNeedMatchAry[MedHLYY_SeqNo]=oneMedHLYY;
	            }
	            var MaxOrderSeqNo="";
				if(HLYYLayOut=="CMOEOrd"){
					var PrescOrderItemAry=OrderItemStr.split(String.fromCharCode(2));
					var tmpOrderItemStr=PrescOrderItemAry[1];
					var OrderItemAry=tmpOrderItemStr.split(String.fromCharCode(1));
		            for (var i=0;i<OrderItemAry.length;i++) {
		                var oneOrderItemAry=OrderItemAry[i].split('^');
		                var ArcimId=oneOrderItemAry[0];
		                var OrderSeqNo=oneOrderItemAry[7];
		                var OrderHLYYInfo=oneOrderItemAry[17];
		                if (MedHLYYNeedMatchAry[OrderSeqNo]) {
			                //将审方返回信息拼到合理用药审查信息字段，后台需要回传给审方系统
			                //之所以用数组是审方系统也要保存返回值
			                var OrderHLYYInfoAry=OrderHLYYInfo.split(String.fromCharCode(4));
			                OrderHLYYInfoAry[0]=MedHLYYNeedMatchAry[OrderSeqNo];
			                oneOrderItemAry[17]=OrderHLYYInfoAry.join(String.fromCharCode(4));;
		                }
		                MaxOrderSeqNo=OrderSeqNo;
		                var oneOrderItemStr=oneOrderItemAry.join('^');
		                OrderItemAry[i]=oneOrderItemStr
		            }
		            var tmpOrderItemStr=OrderItemAry.join(String.fromCharCode(1));
		            PrescOrderItemAry[1]=tmpOrderItemStr;
		            OrderItemStr=PrescOrderItemAry.join(String.fromCharCode(2));
				}else{
					var OrderItemAry=OrderItemStr.split(String.fromCharCode(1));
		            for (var i=0;i<OrderItemAry.length;i++) {
		                var oneOrderItemAry=OrderItemAry[i].split('^');
		                var ArcimId=oneOrderItemAry[0];
		                var OrderSeqNo=oneOrderItemAry[19];
		                var OrderHLYYInfo=oneOrderItemAry[92];
		                if (MedHLYYNeedMatchAry[OrderSeqNo]) {
			                //将合理用药审查信息拼到合理用药审查信息字段，后台需要回传给合理用药系统
			                //之所以用数组是审方系统也要保存返回值
			                var OrderHLYYInfoAry=OrderHLYYInfo.split(String.fromCharCode(4));
			                OrderHLYYInfoAry[0]=MedHLYYNeedMatchAry[OrderSeqNo];
			                
			                oneOrderItemAry[92]=OrderHLYYInfoAry.join(String.fromCharCode(4));
		                }
		                MaxOrderSeqNo=OrderSeqNo;
		                var oneOrderItemStr=oneOrderItemAry.join('^');
		                OrderItemAry[i]=oneOrderItemStr
		            }
		            OrderItemStr=OrderItemAry.join(String.fromCharCode(1));
				}
	            
	            return OrderItemStr;
			}else{
				return OrderItemStr;	
			}	
		}
	}
})

/**
* CreateDate: 	2023-02-24
* Version:		V1.0
* Creator:		nk
* 厂商： 		东华医为审方系统
* scripts/dhcdoc/interface/iMedical/PrescAudit.js
* Description:	封装审方系统方法
* 				重写js,按照医生站标准接口层规范编写
*
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var _m_DHCPrescAudit_AdtMsgID="";
	var DHCPrescAuditObj = {
		Name:"iMedical_PrescAudit",
		//医嘱录入
		OEOrd:{
			Init:function(){
			},
			//审核前
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				DHCPrescAudit_Funcs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"OEOrd");
			}
		},
		//中草药录入
		CMOEOrd:{
			Init:function(){
			},
			//审核前
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				DHCPrescAudit_Funcs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"CMOEOrd");
			}
		},
		Funcs:{
			//医为审方消息通知
			ShowAuditPopProcess:function(){
			}
	    }
	}
	Common_ControlObj.InterfaceArr.push(DHCPrescAuditObj)
	//
	var DHCPrescAudit_Funcs={
		//医为审方消息通知
		ShowAuditPopProcess:function(){
			
		},
		BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr,HLYYLayOut){
			new Promise(function(resolve){
				try{
					DHCPrescAudit_Funcs.DHCAudit(EpisodeID,OrderItemStr,resolve,HLYYLayOut);
				}catch(e){
					$.messager.alert("提示", "医为审方系统自动验证通过:"+e.message, "info",function(){
						resolve(true);
					});
				}
			}).then(function(AuditObj){
				/**
				*返回结果
				* option:对象说明
				* option.AdtMsgID：在第一次调用处方审核接口后，返回的对象中有一个AdtMsgID, 之后的每一次调用都需要将AdtMsgID值赋值到入参信息中进行调用，直到界面刷新或者医嘱生成后,AdtMsgID要置为空。
				* option.AdtPassFlag:Y(药师审核通过) A(自动审核通过) N(审核不通过阻断医嘱审核)
				* option.AdtUniqueStr="";  // 药品唯一标识串  unique(流水号)_"^"_arciId(医嘱项id)_"^"_seqNo(医嘱序号)_"^"_drugPassFlag(药品通过标志Y/N)多条标识串由!!分割
				*/
				if ((AuditObj=="")||(AuditObj==null)||(typeof AuditObj=="undefined")) {
					//不需要调用合理用药或者程序异常
					CallBackFunc({SuccessFlag:true,UpdateFlag:false});
					return;
				}
				if (AuditObj.AdtPassFlag=="N") {
					_m_DHCPrescAudit_AdtMsgID = AuditObj.AdtMsgID;
					$.messager.popover({msg:"审方系统药师拒绝审核,请确认.",type:"success",timeout:2000});
					CallBackFunc({
						SuccessFlag:false,UpdateFlag:false
					});
				}
				else if (AuditObj.AdtPassFlag=="Y" || AuditObj.AdtPassFlag=="A") {
					var UpdateOrderItemStr=DHCPrescAudit_Funcs.ResetOrderItemStr(OrderItemStr,AuditObj,HLYYLayOut);
					CallBackFunc({
						SuccessFlag:true,
						UpdateFlag:true,
						OrderItemStr:UpdateOrderItemStr,
						UpdateOrderItemStr:UpdateOrderItemStr
					});
					_m_DHCPrescAudit_AdtMsgID="";
				}else{
					$.messager.confirm('确认对话框',"医为审方系统系统异常!"+"<br>"+"请联系信息中心!若确认审核医嘱请点击【确定】", function(r){
						if (r) {
							//var UpdateOrderItemStr=DHCPrescAudit_Funcs.ResetOrderItemStr(OrderItemStr,AuditObj,HLYYLayOut);
							CallBackFunc({
								SuccessFlag:true,
								UpdateFlag:false
								//UpdateOrderItemStr:UpdateOrderItemStr
							});
							_m_DHCPrescAudit_AdtMsgID="";
						}else{
							CallBackFunc({SuccessFlag:false,UpdateFlag:false});
						}
					});
				}
				return;
			});
		},
		//审核医嘱(合并医嘱录入/中草药录入,后台拆分数据)
		DHCAudit:function (EpisodeID,OrderItemStr,CallBackFunc,HLYYLayOut){
			var ScreenDataObj=DHCPrescAudit_Funcs.HisScreenData(EpisodeID,OrderItemStr,HLYYLayOut);

			var PdssObj=ScreenDataObj.Patient;
			if(!PdssObj){
				CallBackFunc();
				return "";
			}	
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
				var pdss_chkInfo=GlobalObj.hlyy_pdss_chkInfo;
				if(typeof pdss_chkInfo == "undefined")pdss_chkInfo="1";
				DHCPdss.audit(PdssObj, resolve, pdss_chkInfo);  /// 调用审查接口
			}).then(function(PdssOption){
				if(typeof CallBackFunc == "function"){
					CallBackFunc(PdssOption);
				}
			});
		},
		HisScreenData:function (EpisodeID,OrderItemStr,HLYYLayOut){
			//用户id^科室id^院区id^安全组id^系统模式(用于区分互联网医院,前台录入可为空)^审方回调ID
			var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']+"^"+session['LOGON.GROUPID']+"^";
				ExpStr=ExpStr+"^"+_m_DHCPrescAudit_AdtMsgID;
			var PrescObj=$.cm({
				ClassName:"web.DHCDocHLYYDHC",
				MethodName:"GetPrescInfo",
				EpisodeID:EpisodeID,
				Action:"Audit",
				OrderItemStr:OrderItemStr,
				HLYYLayOut:HLYYLayOut,
				ExpStr:ExpStr
			},false)
			//console.log(PrescJSON)
			if (PrescObj.ResultCode=="-1") {
				$.messager.alert("提示",PrescObj.ResultContent);
				return false;
			}
			if(JSON.stringify(PrescObj) == "{}"){
				return false;	
			}
			return PrescObj;
		},
		ResetOrderItemStr:function(OrderItemStr,MedAuditObj,HLYYLayOut){
			var _m_AdtMsgID=MedAuditObj.AdtMsgID;
			var MedAuditInfo=MedAuditObj.AdtUniqueStr;
			//将审方信息更新到医嘱串中
			if(typeof(MedAuditInfo)!="undefined"){
				var MedAuditNeedMatchAry=new Array();
				//药品唯一标识串  unique(药品唯一标识-安全用药生成)_"^"_arciId(医嘱项id)_"^"_seqNo(医嘱序号)_"^"_drugPassFlag(药品通过标志Y/N)
				//多条标识串由!!分割
				var MedAuditArr=MedAuditInfo.split("!!");
	            for (var i=0;i<MedAuditArr.length;i++) {
	                var oneMedAudit=MedAuditArr[i].split('^');
	                var MedAudit_unique=oneMedAudit[0];
	                var MedAudit_SeqNo=oneMedAudit[2];
	                var MedAudit_drugPassFlag=oneMedAudit[3];
	                var oneMedHLYY=oneMedAudit.join(String.fromCharCode(3));
	                MedAuditNeedMatchAry[MedAudit_SeqNo]={
		                drugPassFlag: MedAudit_drugPassFlag,
		                chkInfo: oneMedHLYY
	                }
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
		                if (MedAuditNeedMatchAry[OrderSeqNo]) {
			                //将审方返回信息拼到合理用药审查信息字段，后台需要回传给审方系统
			                //之所以用数组是合理用药系统也要保存返回值
			                var OrderHLYYInfoAry=OrderHLYYInfo.split(String.fromCharCode(4));
			                OrderHLYYInfoAry[1]=MedAuditNeedMatchAry[OrderSeqNo].chkInfo;
			                
			                oneOrderItemAry[17]=OrderHLYYInfoAry.join(String.fromCharCode(4));
			                oneOrderItemAry[18]=MedAuditNeedMatchAry[OrderSeqNo].drugPassFlag;
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
		                if(typeof OrderHLYYInfo == 'undefined')OrderHLYYInfo="";
		                if (MedAuditNeedMatchAry[OrderSeqNo]) {
			                //将审方返回信息拼到合理用药审查信息字段，后台需要回传给审方系统
			                //之所以用数组是合理用药系统也要保存返回值
			                var OrderHLYYInfoAry=OrderHLYYInfo.split(String.fromCharCode(4));
			                OrderHLYYInfoAry[1]=MedAuditNeedMatchAry[OrderSeqNo].chkInfo;
			                
			                oneOrderItemAry[92]=OrderHLYYInfoAry.join(String.fromCharCode(4));
			                oneOrderItemAry[94]=MedAuditNeedMatchAry[OrderSeqNo].drugPassFlag;
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

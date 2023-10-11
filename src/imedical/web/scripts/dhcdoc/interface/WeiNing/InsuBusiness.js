/*
Creater:	jm
CreateDate��2023-02-09
Description:��������ҽ���������ͳһ��װJS
*********************************************
* 1.���ô˽ӿ�ʱ��˶��޸ġ�DHCDoc.Interface.YiBaoJianGuan.LocalData.cls�����ز�������
* 2.����������ڡ�DHCDoc.Interface.YiBaoJianGuan.Business.cls��������ҽ���顢�ٴ���ӿ��Ƿ���ڲ�����������
	<ҽ����>
		##class(%ResultSet).RunQuery("web.DHCINSUPort","GetTarItemInfoByOrdId")
		##class(INSU.OFFBIZ.BL.BIZ00A).InsuDocDetailedAuditService
	<�ٴ���>
		##class(%ResultSet).RunQuery("web.DHCANAdaptor","FindOperationDTO")
* 3.��ѯҽ�����ݽӿ�:������Դ���˵�,��������ҽ���������˵�,��Ҫ��ϵ�Ʒ����޸�
* 4.����һλ���Ե�ҽ������,�������·������ϴ������Ƿ�Ϲ�,�Լ��Ƿ��з��������ķ�������
	w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).CheckBusinessData(EpisodeID,SceneType,Type,UserID)
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var WNInsuBusinessObj = {
		Name:"WeiNing_InsuBusiness",
		//ҽ��¼��
		OEOrd:{
			//��ʼ��
			xhrRefresh:function(EpisodeID,PAAdmType) {
				InsuBusinessFuncs.YBJGBusinessCheck("3101",EpisodeID,PAAdmType);
			},
			//���ǰ,Ŀǰֻ����ʾ,δ������
			BeforeUpdate:function(EpisodeID,PAAdmType,OrderItemStr,CallBackFunc) {
				//InsuBusinessFuncs.YBJGBusinessCheck("3102",EpisodeID,PAAdmType,OrderItemStr,CallBackFunc);
				CallBackFunc(true);
			},
			//��˺�
			AfterUpdate:function(EpisodeID,PAAdmType) {
				InsuBusinessFuncs.YBJGBusinessCheck("3102",EpisodeID,PAAdmType);
			}
		},
		//�в�ҩ¼��
		CMOEOrd:{
			//��ʼ��
			xhrRefresh:function(EpisodeID,PAAdmType) {
				InsuBusinessFuncs.YBJGBusinessCheck("3101",EpisodeID,PAAdmType);
			},
			//��˺�
			AfterUpdate:function(EpisodeID,PAAdmType) {
				InsuBusinessFuncs.YBJGBusinessCheck("3102",EpisodeID,PAAdmType);
			}
		},
		OPAdm:{
			//�Һ�-�ɹ���
			AfterReg:function(EpisodeID,PAAdmType) {
				InsuBusinessFuncs.YBJGBusinessCheck("1",EpisodeID,PAAdmType);
			}
		},
		Funcs:{
			//����ҵ�����ĵ���
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
					��ǰ������1:����Һ�,2:�����շѵǼ�,3:סԺ�Ǽ�,4:סԺ�շѵǼ�,5:סԺִ��ҽ��
					���г�����6:�������;7:����Ԥ����;	8:סԺ����;9:סԺԤ����;  10:��ҩ����		
				*/
				var SceneType="";
				if(Type=="3101"){		//��ǰ����
					SceneType=PAAdmType != "I"?2:4
				}else if(Type=="3102"){	//���о���
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
									title:'ҽ�����ƽ̨����',
									width:'78%',height:'50%'
								});
							}
						}
					}else{
						if(msg!=""){
							$.messager.alert("ҽ�����ƽ̨����",msg, 'info');
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
				$.messager.alert("���ü��ƽ̨����", e.message, 'error');
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

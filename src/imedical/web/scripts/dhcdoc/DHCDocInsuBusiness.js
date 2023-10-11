/*
**	Creater��
	CreateDate��2022-09-13
	Filename:DHCDocInsuBusiness.js
	Description������ҽ���������
*/
var InsuBusinessConfigObj = {
	EnableFlag: "N" //�Ƿ�����
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
				��ǰ������1:����Һ�,2:�����շѵǼ�,3:סԺ�Ǽ�,4:סԺ�շѵǼ�,5:סԺִ��ҽ��
				���г�����6	�������;7	����Ԥ����;8	סԺ����;9	סԺԤ����;10	��ҩ����		
			*/
			var PAAdmType=argObj.PAAdmType;
			var EpisodeID=argObj.EpisodeID;
			var OrderItemStr=argObj.OrderItemStr;
			if(typeof OrderItemStr == "undefined"){
				OrderItemStr="";
			}
			var SceneType=""
			if(Type=="3101"){    ///��ǰ����
				SceneType=PAAdmType != "I"?2:4
			}else if(Type=="3102"){  //���о���
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
								title:'ҽ�����ƽ̨����',
								width:'78%',height:'50%'
							});
						}
					}
				}else{
					if(msg!=""){
						$.messager.alert("ҽ�����ƽ̨����",msg, 'info');
					}
				}
			});
		}catch(e){$.messager.alert("���ü��ƽ̨����", e.message, 'error');}	
	}
	
	return {
		"YBJGBusinessCheck":YBJGBusinessCheck,
		"GetEnableFlag":GetEnableFlag
	}
})()
InsuBusiness.GetEnableFlag();
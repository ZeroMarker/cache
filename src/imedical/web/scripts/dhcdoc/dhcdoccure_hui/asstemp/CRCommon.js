 /**
 *record.common.js
 *�Ե����ṹ��ģ���Ԫ�ش���
 **/
var CRCommon=(function(){
	function Init(){
		for(key in CureDefSetObj){
			setEleValue(key,CureDefSetObj[key])
		}
		InitCurePOA(ServerObj.DCARowId);
		PageInit();
	}
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		return ""
	}
	
	function PageInit(){
		//���ù��ܳ�ʼ��
		if(typeof comAssConsTrePro=="object"){
			comAssConsTrePro.Init("DCRContent");
		}
		if(ServerObj.DCRRowId==""){
			var trs = $("tr[class='ifhidden']"); 
			for(i = 0; i < trs.length; i++){ 
				trs[i].style.display = "none";
			}
		}else{
			$("#DCRCureExecDate").datetimebox("disable");
		}
		//˫ǩ����
		if(ServerObj.CureLocReconfirm=="0"){
			var trs = $("tr[class='t-psd-hidden']"); 
			for(i = 0; i < trs.length; i++){ 
				trs[i].style.display = "none";
			}	
		}else{	
			$('#ReConfirmUserPin').bind('keydown', function(event){  
				if(event.keyCode==13)
				{
					var argObj={
						UserCodeElement:"ReConfirmUser",
						UserPinElement:"ReConfirmUserPin"	
					}
				   	ReConfirmFun.PasswordOnKeyDown(argObj);
				}
			});	
			
			$('#ReConfirmUser').bind('keydown', function(event){
				if(event.keyCode==13)
				{
					var argObj={
						UserCodeElement:"ReConfirmUser",
						UserPinElement:"ReConfirmUserPin"	
					}
				   	ReConfirmFun.UserOnKeyDown(argObj);	
				}
			})
		}
	}
	//��λѨλ�������ʼ��
	function InitCurePOA(DCARowID,callBack){
		$HUI.combobox("#DCRCurePOA",{
			multiple:true,
			editable:false,
			rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
			selectOnNavigation:false,
			url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=FindCureItemPOA&DCARowId="+DCARowID+"&ResultSetType=array",
			valueField:'CAPPartDR',
			textField:'CAPPart',
			onLoadSuccess:function(){
				var data=$(this).combobox("getData");
				if(data.length==0){
					$(this).combobox("disable");	
				}
				if(typeof(callBack)=='function'){
					callBack();	
				}
			}
		})
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
		"PageInit":PageInit,
		"InitCurePOA":InitCurePOA
	}
})();
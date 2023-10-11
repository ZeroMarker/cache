 /**
 *record.common.js
 *对单个结构化模板的元素处理
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
		//引用功能初始化
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
		//双签功能
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
	//部位穴位下拉框初始化
	function InitCurePOA(DCARowID,callBack){
		$HUI.combobox("#DCRCurePOA",{
			multiple:true,
			editable:false,
			rowStyle:'checkbox', //显示成勾选行形式
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
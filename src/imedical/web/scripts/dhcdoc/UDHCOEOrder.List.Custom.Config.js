//UDHCOEOrder.List.Custom.Config.js
jQuery(document).ready(function(){
	var NurseFlag= tkMakeServerCall("web.DHCDocMain","isNurseLogin");
	if (NurseFlag=="1"){
		var DefaultPatListType = tkMakeServerCall("web.DHCDocMain","GetDefaultPatListType");
		//$("#PatListDefaultParam_1").hide();
		//$('#PatListDefaultParam_1').panel('header')[0].innerHTML="";
		$("#Chart_2").hide();
		$('#Chart_2').panel('header')[0].innerHTML="";


	}
	jQuery("#Submit").bind({click:submitForm});
	jQuery("#ExitForm").bind({click:ExitForm});
	
	//导入数据
	var UserID=session['LOGON.USERID'];
	//jQuery("#fUIConfig").form("load","oeorder.oplistcustom.new.request.csp?action=Config_Get")
	jQuery.get("oeorder.oplistcustom.new.request.csp?action=Config_Get&UserID="+UserID,function(data){
	  	var data = eval('(' + data + ')');
		jQuery("#layoutConfig1").attr("checked",data.layoutConfig1)
		jQuery("#layoutConfig2").attr("checked",data.layoutConfig2)
		jQuery("#OrderPriorConfig1").attr("checked",data.OrderPriorConfig1)
		jQuery("#OrderPriorConfig2").attr("checked",data.OrderPriorConfig2)
		jQuery("#ShowList1").attr("checked",data.ShowList1)
		jQuery("#ShowList2").attr("checked",data.ShowList2)
	  	jQuery("#DefaultExpendList").attr("checked",data.DefaultExpendList)
	  	jQuery("#DefaultExpendTemplate").attr("checked",data.DefaultExpendTemplate)
		jQuery("#DefaultCloseList").attr("checked",data.DefaultCloseList)
	  	jQuery("#BigFont").attr("checked",data.BigFont)
	  	jQuery("#SmallFont").attr("checked",data.SmallFont)
	  	jQuery("#ShowGridFootBar").attr("checked",data.ShowGridFootBar)
		jQuery("#isEditCopyItem").attr("checked",data.isEditCopyItem)
		jQuery("#isSetTimeLog").attr("checked",data.isSetTimeLog)
	});
	/*var PatSearchDefCon=tkMakeServerCall("web.DHCDocConfig","GetConfigNode1","PatSearchDefCon",session['LOGON.USERID']);
	if (PatSearchDefCon!=""){
		$($('input:radio[name="PatFind"]')[PatSearchDefCon]).attr("checked",true)
	}*/
	
	jQuery.get("oeorder.oplistcustom.new.request.csp?action=ViewGroupSum_Get&UserID="+UserID,function(data){
  		var data = eval('(' + data + ')');
  		jQuery("#ViewGroupSum_UserID").val(data);
		

	});
});

function submitForm(){
	var UserID=session['LOGON.USERID'];
	jQuery("#fUIConfig").form("submit",{
		url : "oeorder.oplistcustom.new.request.csp?action=Config_Set&UserID="+UserID ,
		onSubmit: function(param){
			//var patSearchDefCon=$('input:radio[name="PatFind"]:checked').val()
			//if (patSearchDefCon==undefined) patSearchDefCon="";
			// do some check
			// return false to prevent submit;
		    param.layoutConfig1=jQuery("#layoutConfig1").attr("checked")=="checked"?true:false;
			param.layoutConfig2=jQuery("#layoutConfig2").attr("checked")=="checked"?true:false;	
			param.OrderPriorConfig1=jQuery("#OrderPriorConfig1").attr("checked")=="checked"?true:false;
			param.OrderPriorConfig2=jQuery("#OrderPriorConfig2").attr("checked")=="checked"?true:false;	
			param.ShowList1=jQuery("#ShowList1").attr("checked")=="checked"?true:false;
			param.ShowList2=jQuery("#ShowList2").attr("checked")=="checked"?true:false;			
			param.DefaultExpendList=jQuery("#DefaultExpendList").attr("checked")=="checked"?true:false;
			param.DefaultExpendTemplate=jQuery("#DefaultExpendTemplate").attr("checked")=="checked"?true:false;
			param.BigFont=jQuery("#BigFont").attr("checked")=="checked"?true:false;
			param.SmallFont=jQuery("#SmallFont").attr("checked")=="checked"?true:false;
			param.ShowGridFootBar=jQuery("#ShowGridFootBar").attr("checked")=="checked"?true:false;
			param.isEditCopyItem=jQuery("#isEditCopyItem").attr("checked")=="checked"?true:false;
			param.DefaultCloseList=jQuery("#DefaultCloseList").attr("checked")=="checked"?true:false;
			param.isSetTimeLog=jQuery("#isSetTimeLog").attr("checked")=="checked"?true:false;
			//param.PatSearchDefCon=patSearchDefCon;
			
			// 中成药列数据
			param.ViewGroupSum_UserID=jQuery("#ViewGroupSum_UserID").find("option:selected").text(); 
			/*
			param.DefaultExpendList=jQuery("#DefaultExpendList").val();
			param.DefaultExpendTemplate=jQuery("#DefaultExpendTemplate").val();
			param.BigFont=jQuery("#BigFont").val();
			param.SmallFont=jQuery("#SmallFont").val();
			param.ShowGridFootBar=jQuery("#ShowGridFootBar").val();
			*/
		},
		success:function(data){
			debugger;
			var data = eval('(' + data + ')');
			if (data.success) {
				alert(data.message)
				//刷新父窗口
				var Url=window.opener.location.href
				if((Url.indexOf("copyOeoris")>0)||(Url.indexOf("copyTo")>0)){
					var HeadUrl=Url.split("?")[0]
					var BackUrl=Url.split("?")[1]
					var strArr=BackUrl.split("&")
				    var strArrNew=strArr.slice(0,strArr.length-2)
				    var NewStr=strArrNew.join("&")+"&copyOeoris=&copyTo=";
				    var Url=HeadUrl+"?"+NewStr
				}
				window.opener.location.href = Url //window.opener.location.href;
				//window.parent.parent.location.reload();
				//关闭窗口 
				window.close();		
			}
		}
	});
}
function ExitForm(){
	window.close();
}

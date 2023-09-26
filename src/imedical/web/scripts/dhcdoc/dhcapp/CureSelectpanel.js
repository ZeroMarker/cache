﻿var CureSelectpanel=(function(){
	function Init(){
		LoadTestItemList();
		LoadOtherInfo();
	}
	function LoadTestItemList(){
		$("#CureSelect").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonCureSelect",{"HospID":LgHospID},function(jsonString){

			if (jsonString != ""){
				var jsonObjArr = jsonString;
				for (var i=0; i<jsonObjArr.length; i++){
					InsTesItemRegion(jsonObjArr[i]);
				}
			}
		},'json',false)
		}
	function InsTesItemRegion(itemobj){
		var htmlstr = '';
		htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';
		var itemArr = itemobj.items;
		var itemhtmlArr = []; itemhtmlstr = "";
		for (var j=1; j<=itemArr.length; j++){
			var InputHtml = "";
			if (itemArr[j-1].text == "其他"){
			   InputHtml = '<input type="text" class="name-input-80" id="CureSelect'+ itemArr[j-1].value +'"></input>';
			}
			itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text +InputHtml+'</td>');
			if (j % 4 == 0){
				itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}
		}
		if ((j-1) % 4 != 0){
			itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
			itemhtmlArr = [];
		}
		$("#CureSelect").append(htmlstr+itemhtmlstr)
		InitPageCheckBox()
		}
	function InitPageCheckBox(){
		
		$("input[name=CureSelect]").click(function(){
			if ($(this).parent().next().text() == "其他"){
				if($("[value='"+this.id+"'][name=CureSelect]").is(':checked')){
					/// 选中
					$("#CureSelect"+ this.id).show();
				}else{
					/// 取消
					$("#CureSelect"+ this.id).hide();
				}
			}
			var TypeID=this.id
			$("input[name=CureSelect]").each(function(){
				if (TypeID!=this.id){
					$("input[name=CureSelect][value='"+this.id+"']").removeAttr("checked");}
			});
			
		});
	}
	function LoadOtherInfo(){
		var OtherInfo=""
		if (itemReqJsonStr!=""){
			for (var i = 0; i < itemReqJsonStr.length; i++) {
				var OneReqJson=itemReqJsonStr[i]
				var ID=OneReqJson.ID
				var Val=OneReqJson.Val
				if (ID=="OtherInfo") OtherInfo=Val
			}
		}
		if (OtherInfo!=""){
			OtherObj=$.parseJSON(OtherInfo);
			if (OtherObj["mCureSelect"]){ 
			mPisTesItm=$.parseJSON(OtherObj["mCureSelect"])
			for (var i = 0; i < mPisTesItm.length; i++) {
				var Psiarry=mPisTesItm[i]
				var PsiID=Psiarry.split("^")[0]
				var PisTesItmArr = $("input[name=CureSelect]");
	    		for (var j=0; j < PisTesItmArr.length; j++){
		    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
							if ($('#'+PsiID).parent().next().text() == "其他"){
									$("#CureSelect"+ PsiID).show();
									$("#CureSelect"+ PsiID).val(Psiarry.split("^")[1]);
								}
			    		}
		    		}
				}
			}
		}
	}
	function OtherInfo(){
		var mPisTesDiagArr=[]; var mPisTesDiag="";
		var TesDiagArr = $("input[name=CureSelect]");
		for (var j=0; j < TesDiagArr.length; j++){
		    if($("[value='"+TesDiagArr[j].value+"'][name=CureSelect]").is(':checked')){
				var TestItem = "";
			    if ($('#'+TesDiagArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#SentOrder"+ TesDiagArr[j].id).val();
				}
				mPisTesDiagArr.push(TesDiagArr[j].value+"^"+ TestItem);
		    }
		}
		var mCureSelect = JSON.stringify(mPisTesDiagArr);
		var rtnObj = {}
		rtnObj["mCureSelect"] = mCureSelect;
		return rtnObj
	}
	function PrintInfo(){
		
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();
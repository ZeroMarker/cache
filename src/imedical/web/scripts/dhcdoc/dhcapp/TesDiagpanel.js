var TesDiagpanel=(function(){
	function Init(){
		LoadTestItemList();
		LoadOtherInfo();
		InitPageCheckBox();
	}
	function LoadTestItemList(){
		$("#TesDiag").html('<tr style="height:0px;" ><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonTesDiag",{"HospID":LgHospID},function(jsonString){

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
		//htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';
		var itemArr = itemobj.items;
		var itemhtmlArr = []; itemhtmlstr = "";
		for (var j=1; j<=itemArr.length; j++){
			var InputHtml = "";
			if (itemArr[j-1].text == "其他"){
			   InputHtml = '<input type="text" class="name-input-80" id="TesDiag'+ itemArr[j-1].value +'"></input>';
			}
			if (j % 4 == 0){
				itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" class="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td style="border-right:none;">'+ itemArr[j-1].text +InputHtml+'</td>');
				itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}else{
				itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" class="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text +InputHtml+'</td>');
				}
		}
		if ((j-1) % 4 != 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
			itemhtmlArr = [];
		}
		$("#TesDiag").append(htmlstr+itemhtmlstr)
		//InitPageCheckBox()
		}
	function InitPageCheckBox(){
		
		$("input[name=TesDiag]").click(function(){
			if ($(this).parent().next().text() == "其他"){
				if($("[value='"+this.id+"'][name=TesDiag]").is(':checked')){
					/// 选中
					$("#TesDiag"+ this.id).show();
				}else{
					/// 取消
					$("#TesDiag"+ this.id).hide();
				}
			}
			var TypeID=this.id
			$("input[name=TesDiag]").each(function(){
				if (TypeID!=this.id){
					$("input[name=TesDiag][value='"+this.id+"']").removeAttr("checked");}
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
			if (OtherObj["mPisTesDiag"]){
			mPisTesItm=$.parseJSON(OtherObj["mPisTesDiag"])
			for (var i = 0; i < mPisTesItm.length; i++) {
				var Psiarry=mPisTesItm[i]
				var PsiID=Psiarry.split("^")[0]
				var PisTesItmArr = $("input[name=TesDiag]");
	    		for (var j=0; j < PisTesItmArr.length; j++){
		    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
							if ($('#'+PsiID).parent().next().text() == "其他"){
									$("#TesDiag"+ PsiID).show();
									$("#TesDiag"+ PsiID).val(Psiarry.split("^")[1]);
								}
			    		}
		    		}
				}
			}
		}
	}
	function OtherInfo(){
		var mPisTesDiagArr=[]; var mPisTesDiag="";
		var TesDiagArr = $("input[name=TesDiag]");
		for (var j=0; j < TesDiagArr.length; j++){
		    if($("[value='"+TesDiagArr[j].value+"'][name=TesDiag]").is(':checked')){
			    var TestItem = "";
			    if ($('#'+TesDiagArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#TesDiag"+ TesDiagArr[j].id).val();
				}
				mPisTesDiagArr.push(TesDiagArr[j].value+"^"+ TestItem);
		    }
		}
		var mPisTesDiag = JSON.stringify(mPisTesDiagArr);
		var rtnObj = {}
		rtnObj["mPisTesDiag"] = mPisTesDiag;
		return rtnObj
	}
	function PrintInfo(){
		var PisReqSpec=""
	    var PatSpecArr = $("input[name^=TesDiag]");
	    var i = 1;
	    for (var j=0; j < PatSpecArr.length; j++){
		    if($("[value='"+PatSpecArr[j].value+"'][name^=TesDiag]").is(':checked')){
			    var PisSpecDesc = $("[value='"+PatSpecArr[j].value+"'][name^=TesDiag]").parent().next().text();
				if ($('#'+PatSpecArr[j].id).parent().next().text() == "其他"){
					PisSpecDesc = $("#TesDiag"+ PatSpecArr[j].id).val();
				}
				if (PisReqSpec==""){
					PisReqSpec = PisSpecDesc 
				}else{
					PisReqSpec = PisReqSpec+","+PisSpecDesc
				}
		    }
		}
		var rtnObj = {}
		rtnObj["TesDiag"] = PisReqSpec;
		return rtnObj
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();
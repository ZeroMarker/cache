var PatRecpanel=(function(){
	function Init(){
		LoadTestItemList();
		LoadOtherInfo();
	}
	function LoadTestItemList(){
		$("#PatRec").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonPatRec",{"HospID":LgHospID},function(jsonString){

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
			   InputHtml = '<input type="text" class="name-input-80" id="PatRec'+ itemArr[j-1].value +'"></input>';
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
		$("#PatRec").append(htmlstr+itemhtmlstr)
		//InitPageCheckBox()
		}
	function InitPageCheckBox(){
		
		$("input[name=PatRec]").click(function(){
			if ($(this).parent().next().text() == "其他"){
				if($("[value='"+this.id+"'][name=PatRec]").is(':checked')){
					/// 选中
					$("#PatRec"+ this.id).show();
				}else{
					/// 取消
					$("#PatRec"+ this.id).hide();
				}
			}
			var TypeID=this.id
			$("input[name=PatRec]").each(function(){
				if (TypeID!=this.id){
					$("input[name=PatRec][value='"+this.id+"']").removeAttr("checked");}
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
			if (OtherObj["mPisPatRec"]){
			mPisTesItm=$.parseJSON(OtherObj["mPisPatRec"])
			for (var i = 0; i < mPisTesItm.length; i++) {
				var Psiarry=mPisTesItm[i]
				var PsiID=Psiarry.split("^")[0]
				var PisTesItmArr = $("input[name=PatRec]");
	    		for (var j=0; j < PisTesItmArr.length; j++){
		    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
							if ($('#'+PsiID).parent().next().text() == "其他"){
									$("#PatRec"+ PsiID).show();
									$("#PatRec"+ PsiID).val(Psiarry.split("^")[1]);
								}
			    		}
		    		}
				}
			mPisTesItm=$.parseJSON(OtherObj["mPisTesDiag"])
			}
		}
	}
	function OtherInfo(){
		var mPisPatRec=""; mPisPatRecArr = [];
	    var PatRecArr = $("input[name=PatRec]");
	    for (var j=0; j < PatRecArr.length; j++){
		    if($('#'+PatRecArr[j].id).is(':checked')){
			    var TestItem = "";
			    if ($('#'+PatRecArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#SentOrder"+ PatRecArr[j].id).val();
				}
				mPisPatRecArr.push(PatRecArr[j].value+"^"+ TestItem);
				//mPisPatRecArr.push(PatRecArr[j].value);
		    }
		}
		var mPisPatRec = JSON.stringify(mPisPatRecArr);
		var rtnObj = {}
		rtnObj["mPisPatRec"] = mPisPatRec;
		rtnObj["PisReqSpec"] = 1+"#"+"宫颈脱落细胞" +"#"+ 1 +"#"+ "" + +"#"+ 1+ "#"+ "";
		return rtnObj
	}
	function PrintInfo(){
		var PisReqSpec=""
	    var PatSpecArr = $("input[name^=PatRec]");
	    var i = 1;
	    for (var j=0; j < PatSpecArr.length; j++){
		    if($("[value='"+PatSpecArr[j].value+"'][name^=PatRec]").is(':checked')){
			    var PisSpecDesc = $("[value='"+PatSpecArr[j].value+"'][name^=PatRec]").parent().next().text();
				if (PisReqSpec==""){
					PisReqSpec = PisSpecDesc 
				}else{
					PisReqSpec = PisReqSpec+","+PisSpecDesc
				}
		    }
		}
		var rtnObj = {}
		rtnObj["PisPatRec"] = PisReqSpec;
		return rtnObj
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();
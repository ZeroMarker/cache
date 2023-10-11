var SpceTypepanel=(function(){
	function Init(){
		LoadTestItemList();
		LoadOtherInfo();
	}
	function LoadTestItemList(){
		$("#SpceType").html('<tr style="height:0px;" ><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonBaseItemList",{"Title":"标本类型", "Name":"SpceTypelist", "Type":MapCode,"HospID":LgHospID},function(jsonString){

			if (jsonString != ""){
				var jsonObjArr = jsonString;
				for (var i=0; i<jsonObjArr.length; i++){
					InsTesItemRegion(jsonObjArr[i]);
				}
			}
		},'json',false)
		$.cm({
			ClassName:"web.DHCAppPisDicRelationBLMap",
			MethodName:"GetOneItemDefault",
			MapCode:MapCode,
			Title:"标本类型",
			dataType:"text",
		},function(data){
			if ((data!="")&&(PisID=="")){
				$('#'+data).attr("checked",true);
				if ($('#'+data).parent().next().text() == "其他"){
						$("#SpceType"+ data).show();
				}
			}
		})
	}
	function InsTesItemRegion(itemobj){
		var htmlstr = '';
		//htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';
		var itemArr = itemobj.items;
		var itemhtmlArr = []; itemhtmlstr = "";
		for (var j=1; j<=itemArr.length; j++){
			var InputHtml = "";
			if (itemArr[j-1].text == "其他"){
			   InputHtml = '<input type="text" class="name-input-80" id="SpceType'+ itemArr[j-1].value +'"></input>';
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
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td style="border-right:none;"></td></tr>';
			itemhtmlArr = [];
		}
		$("#SpceType").append(htmlstr+itemhtmlstr)
		InitPageCheckBox()
	}
	function InitPageCheckBox(){
		
		$("input[name=SpceTypelist]").click(function(){
			if ($(this).parent().next().text() == "其他"){
				if($("[value='"+this.id+"'][name=SpceTypelist]").is(':checked')){
					/// 选中
					$("#SpceType"+ this.id).show().focus();
				}else{
					/// 取消
					$("#SpceType"+ this.id).val("").hide();
				}
			}
			var TypeID=this.id
			$("input[name=SpceTypelist]").each(function(){
				if (TypeID!=this.id){
					$("input[name=SpceTypelist][value='"+this.id+"']").removeAttr("checked");
					if ($(this).parent().next().text() == "其他"){
						/// 取消
						$("#SpceType"+ this.id).val("").hide();
					}
				}
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
			if (OtherObj["mSpceType"]) {
				mPisTesItm=$.parseJSON(OtherObj["mSpceType"])
				for (var i = 0; i < mPisTesItm.length; i++) {
					var Psiarry=mPisTesItm[i]
					var PsiID=Psiarry.split("^")[0]
					var PisTesItmArr = $("input[name=SpceTypelist]");
		    		for (var j=0; j < PisTesItmArr.length; j++){
			    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
							if ($('#'+PsiID).parent().next().text() == "其他"){
									$("#SpceType"+ PsiID).show();
									$("#SpceType"+ PsiID).val(Psiarry.split("^")[1]);
								}
				    	}
			    	}
				}
			}
		}
	}
	function OtherInfo(){
		var mPisTesDiagArr=[]; var mPisTesDiag="";
		var TesDiagArr = $("input[name=SpceTypelist]");
		for (var j=0; j < TesDiagArr.length; j++){
		    if($("[value='"+TesDiagArr[j].value+"'][name=SpceTypelist]").is(':checked')){
			    var TestItem = "";
			    if ($('#'+TesDiagArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#SpceType"+ TesDiagArr[j].id).val();
				}
				mPisTesDiagArr.push(TesDiagArr[j].value+"^"+ TestItem);
		    }
		}
		var mCureSelect = JSON.stringify(mPisTesDiagArr);
		var rtnObj = {}
		rtnObj["mSpceType"] = mCureSelect;
		return rtnObj
	}
	function PrintInfo(){
		var FixItem=""
		var TesDiagArr = $("input[name=SpceTypelist]");
		for (var j=0; j < TesDiagArr.length; j++){
		    if($("[value='"+TesDiagArr[j].value+"'][name=SpceTypelist]").is(':checked')){
			     var TestItem = $('#'+TesDiagArr[j].id).parent().next().text() ;
			    if ($('#'+TesDiagArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#SpceType"+ TesDiagArr[j].id).val();
				}
				if (FixItem==""){
					FixItem=TestItem
					}else{
					FixItem=FixItem+","+TestItem
					}
		    }
		}
		var rtnObj = {}
		rtnObj["PisCutBasType"] = FixItem;
		return rtnObj
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();
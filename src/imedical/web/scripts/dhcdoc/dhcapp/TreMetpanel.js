var TreMetpanel=(function(){
	function Init(){
		LoadTestItemList();
		LoadOtherInfo();
	}
	function LoadTestItemList(){
		$("#TreMet").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonBaseItemList",{"Title":"治疗方法", "Name":"TreMet", "Type":MapCode,"HospID":LgHospID},function(jsonString){

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
			Title:"治疗方法",
			dataType:"text",
		},function(data){
			if ((data!="")&&(PisID=="")){
				$('#'+data).attr("checked",true);
				}
		})
		}
	function InsTesItemRegion(itemobj){
		var htmlstr = '';
		htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';
		var itemArr = itemobj.items;
		var itemhtmlArr = []; itemhtmlstr = "";
		for (var j=1; j<=itemArr.length; j++){
			
			itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
			if (j % 4 == 0){
				itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}
		}
		if ((j-1) % 4 != 0){
			itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
			itemhtmlArr = [];
		}
		$("#TreMet").append(htmlstr+itemhtmlstr)
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
			if (OtherObj["mTreMet"]) {
				mPisTesItm=$.parseJSON(OtherObj["mTreMet"])
				for (var i = 0; i < mPisTesItm.length; i++) {
					var Psiarry=mPisTesItm[i]
					var PsiID=Psiarry.split("^")[0]
					var PisTesItmArr = $("input[name=TreMet]");
		    		for (var j=0; j < PisTesItmArr.length; j++){
			    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
				    	}
			    	}
				}
			}
		}
	}
	function OtherInfo(){
		var mPisTesDiagArr=[]; var mPisTesDiag="";
		var TesDiagArr = $("input[name=TreMet]");
		for (var j=0; j < TesDiagArr.length; j++){
		    if($("[value='"+TesDiagArr[j].value+"'][name=TreMet]").is(':checked')){
				mPisTesDiagArr.push(TesDiagArr[j].value);
		    }
		}
		var mCureSelect = JSON.stringify(mPisTesDiagArr);
		var rtnObj = {}
		rtnObj["mTreMet"] = mCureSelect;
		return rtnObj
	}
	function PrintInfo(){
		var FixItem=""
		var TesDiagArr = $("input[name=TreMet]");
		for (var j=0; j < TesDiagArr.length; j++){
		    if($("[value='"+TesDiagArr[j].value+"'][name=TreMet]").is(':checked')){
				if (FixItem==""){
					FixItem=$('#'+TesDiagArr[j].id).parent().next().text() 
					}else{
					FixItem=FixItem+","+$('#'+TesDiagArr[j].id).parent().next().text() 
					}
		    }
		}
		var rtnObj = {}
		rtnObj["TreMet"] = FixItem;
		return rtnObj
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();
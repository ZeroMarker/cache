var TesItmMetpanel=(function(){
	function Init(){
		LoadTestItemList();
		LoadOtherInfo();
	}
	function LoadTestItemList(){
		
		/// 初始化检查方法区域
		$("#TesItmMet").html('<tr style="height:0px;" ><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonBaseItemList",{"Title":"检测方法", "Name":"TesItmMet", "Type":MapCode,"HospID":LgHospID},function(jsonString){

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
			Title:"检测方法",
			dataType:"text",
		},function(data){
			if ((data!="")&&(PisID=="")){
				$('#'+data).attr("checked",true);
				}
		})
	}

	/// 病人传染病史内容
	function InsTesItemRegion(itemobj){	
		/// 标题行
		var htmlstr = '';
			//htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';

		/// 项目
		var itemArr = itemobj.items;
		var itemhtmlArr = []; itemhtmlstr = "";
		for (var j=1; j<=itemArr.length; j++){
			
			var InputHtml = "";
			if (itemArr[j-1].text == "其他"){
			   InputHtml = '<input type="text" class="name-input-80" id="Test'+ itemArr[j-1].value +'"></input>';
			}
			if (j % 4 == 0){
				itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" class="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td style="border-right:none;">'+ itemArr[j-1].text + InputHtml +'</td>');
				itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}else{
				itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox"  class="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text + InputHtml +'</td>');
				}
		}
		if ((j-1) % 4 != 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
			itemhtmlArr = [];
		}
		$("#TesItmMet").append(htmlstr+itemhtmlstr)
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
			if (OtherObj["TesItmMetArr"]) {
				mPisTesItm=$.parseJSON(OtherObj["TesItmMetArr"])
				for (var i = 0; i < mPisTesItm.length; i++) {
					var Psiarry=mPisTesItm[i]
					var PsiID=Psiarry.split("^")[0]
					var PisTesItmArr = $("input[name=TesItmMet]");
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
		mPisTesItmArr = []
		var PisTesItmArr = $("input[name=TesItmMet]");
	    for (var j=0; j < PisTesItmArr.length; j++){
		    if($('#'+PisTesItmArr[j].id).is(':checked')){
			    /// 其他项目判断
			    var TestItem = "";
			    if ($('#'+PisTesItmArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#Test"+ PisTesItmArr[j].id).val();
					if (TestItem == "") {mPisTesFlag=1; break;}
				}
				
				mPisTesItmArr.push(PisTesItmArr[j].value +"^"+ TestItem);
		    }
		}
		var FixItem = JSON.stringify(mPisTesItmArr);
		var rtnObj = {}
		rtnObj["TesItmMetArr"] = FixItem;
		return rtnObj
	}
	function PrintInfo(){
		FixItem=""
		var PisTesItmArr = $("input[name=TesItmMet]");
	    for (var j=0; j < PisTesItmArr.length; j++){
		    if($('#'+PisTesItmArr[j].id).is(':checked')){
			    /// 其他项目判断
			    var TestItem = "";
			    if ($('#'+PisTesItmArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#Test"+ PisTesItmArr[j].id).val();
					if (TestItem == "") {mPisTesFlag=1; break;}
				}
				
				if (FixItem==""){
					FixItem=$('#'+PisTesItmArr[j].id).parent().next().text() 
					}else{
					FixItem=FixItem+","+$('#'+PisTesItmArr[j].id).parent().next().text() 
					}
		    }
		}
		var rtnObj = {}	
		rtnObj["TesItmMet"] = FixItem;
		return rtnObj
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();
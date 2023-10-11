var SentOrderpanel=(function(){
	function Init(){
		LoadTestItemList();
		LoadOtherInfo();
	}
	function LoadTestItemList(){
		$("#SentOrder").html('<tr style="height:0px;" ><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonBaseItemList",{"Title":"送检目的", "Name":"SentOrder", "Type":MapCode,"HospID":LgHospID},function(jsonString){

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
			Title:"送检目的",
			dataType:"text",
		},function(data){
			if ((data!="")&&(PisID=="")){
				$('#'+data).attr("checked",true);
				if ($('#'+data).parent().next().text() == "其他"){
						$("#SentOrder"+ data).show();
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
			   InputHtml = '<input type="text" class="name-input-80" id="SentOrder'+ itemArr[j-1].value +'"></input>';
			}
			if (j % 4 == 0){
				itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" class="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td style="border-right:none;" >'+ itemArr[j-1].text +InputHtml+'</td>');
				itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}else{
				itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" class="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text +InputHtml+'</td>');
				}
			if (itemArr[j-1].text.indexOf("加急")>=0) EmgId=itemArr[j-1].value;
		}
		if ((j-1) % 4 != 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td style="border-right:none;"></td></tr>';
			itemhtmlArr = [];
		}
		$("#SentOrder").append(htmlstr+itemhtmlstr)
		InitPageCheckBox();
	}
	function InitPageCheckBox(){
		
		$("input[name=SentOrder]").click(function(){
			if ($(this).parent().next().text() == "其他"){
				if($("[value='"+this.id+"'][name=SentOrder]").is(':checked')){
					/// 选中
					$("#SentOrder"+ this.id).show();
				}else{
					/// 取消
					$("#SentOrder"+ this.id).hide();
				}
			}
			var TypeID=this.id
			$("input[name=SentOrder]").each(function(){
				if (TypeID!=this.id){
					$("input[name=SentOrder][value='"+this.id+"']").removeAttr("checked");}
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
			if (OtherObj["mSentOrder"]) {
				mPisTesItm=$.parseJSON(OtherObj["mSentOrder"])
				for (var i = 0; i < mPisTesItm.length; i++) {
					var Psiarry=mPisTesItm[i]
					var PsiID=Psiarry.split("^")[0]
					var PisTesItmArr = $("input[name=SentOrder]");
		    		for (var j=0; j < PisTesItmArr.length; j++){
			    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
							if ($('#'+PsiID).parent().next().text() == "其他"){
									$("#SentOrder"+ PsiID).show();
									$("#SentOrder"+ PsiID).val(Psiarry.split("^")[1]);
								}
				    	}
			    	}
				}
			}
		}
	}
	function OtherInfo(){
		var mPisTesDiagArr=[]; var mPisTesDiag="";
		var TesDiagArr = $("input[name=SentOrder]");
		for (var j=0; j < TesDiagArr.length; j++){
		    if($("[value='"+TesDiagArr[j].value+"'][name=SentOrder]").is(':checked')){
				var TestItem = "";
			    if ($('#'+TesDiagArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#SentOrder"+ TesDiagArr[j].id).val();
				}
				mPisTesDiagArr.push(TesDiagArr[j].value+"^"+ TestItem);
		    }
		}
		var mCureSelect = JSON.stringify(mPisTesDiagArr);
		var rtnObj = {}
		rtnObj["mSentOrder"] = mCureSelect;
		return rtnObj
	}
	function PrintInfo(){
		var FixItem=""
		var TesDiagArr = $("input[name=SentOrder]");
		for (var j=0; j < TesDiagArr.length; j++){
		    if($("[value='"+TesDiagArr[j].value+"'][name=SentOrder]").is(':checked')){
				var TestItem =$('#'+TesDiagArr[j].id).parent().next().text() ;
			    if ($('#'+TesDiagArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#SentOrder"+ TesDiagArr[j].id).val();
				}
				if (FixItem==""){
					FixItem=TestItem
					}else{
					FixItem=FixItem+","+TestItem
				}
		    }
		}
		var rtnObj = {}
		rtnObj["SentOrder"] = FixItem;
		return rtnObj
	}
	function SetEmFlag(Emg,EmgFlag,Flost){
		var TesDiagArr = $("input[name=SentOrder]");
		for (var j=0; j < TesDiagArr.length; j++){
			if ($('#'+TesDiagArr[j].id).parent().next().text()=="加急"){
				if (Emg=="1"){
					$("input[name=SentOrder][value='"+TesDiagArr[j].id+"']").attr("checked",true);
				}else{
					$("input[name=SentOrder][value='"+TesDiagArr[j].id+"']").removeAttr("checked");	
					}
				if (EmgFlag=="0"){
					$("input[name=SentOrder][value='"+TesDiagArr[j].id+"']").attr("disabled",true);
					}else{
					$("input[name=SentOrder][value='"+TesDiagArr[j].id+"']").attr("disabled",false);	
					}
				} 
			if ($('#'+TesDiagArr[j].id).parent().next().text()=="冰冻"){
				if (Flost=="1"){
					$("input[name=SentOrder][value='"+TesDiagArr[j].id+"']").attr("checked")
				}
				}
		
		}
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
		"SetEmFlag":SetEmFlag,
	}
	   
})();
var TesItempanel=(function(){
	function Init(){
		LoadTestItemList();
		LoadOtherInfo();
	}
	function LoadTestItemList(){
		/// 初始化检查方法区域
		$("#TesItem").html('<tr style="height:0px;" ><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonTestItemListNew",{"HospID":LgHospID},function(jsonString){

			if (jsonString != ""){
				var jsonObjArr = jsonString;
				for (var i=0; i<jsonObjArr.length; i++){
					InsTesItemRegion(jsonObjArr[i]);
				}
			}
		},'json',false)
		}
	/// 检测项目内容
	function InsTesItemRegion(Subitemobj){	
		/// 标题行
		var htmlstr = '';
			//htmlstr = '<tr style="height:30px"><td colspan="7" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ Subitemobj.text +'</td></tr>';
		 itemhtmlstr = "";
		for (var jj=0; jj<Subitemobj.items.length; jj++){
			var itemobj=Subitemobj.items[jj]
			itemhtmlstr=itemhtmlstr+'<tr style="height:30px"><td style="border:0px solid #ccc;"></td><td colspan="5" class=" " style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';
			var itemArr = itemobj.items;
			var itemhtmlArr = [];
			for (var j=1; j<=itemArr.length; j++){
				itemhtmlArr.push('<td style="width:30px; border-top:1px solid #ddd"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" class="checkbox" value="'+ itemArr[j-1].value +'" inputtype="'+ itemobj.text +'"></input></td ><td  style="border-top:1px solid #ddd">'+ itemArr[j-1].text +'</td>');
				if (j % 3 == 0){
					itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
					itemhtmlArr = [];
				}
			}
			if ((j-1) % 3 != 0){
				itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px;border-top:1px solid #ddd"></td><td style="border-top:1px solid #ddd"></td></tr>';
				itemhtmlArr = [];
			}
		}
		$("#TesItem").append(htmlstr+itemhtmlstr)
		InitPageCheckBox()
	}
	function InitPageCheckBox(){
		
		$("input[name=TestItem]").click(function(){
			var MastInput=$(this).attr("inputtype")
			if($(this).is(':checked')){
				$("input[name=TestItem]").each(function(){
					var SubInput=$(this).attr("inputtype")
					if (MastInput!=SubInput){
						$(this).attr("checked",false);
						//$("input[name=TestItem][value='"+this.id+"']").removeAttr("checked");
						}
					})
				}
			
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
			mPisTesItm=$.parseJSON(OtherObj["mPisTestItem"])
			for (var i = 0; i < mPisTesItm.length; i++) {
				var Psiarry=mPisTesItm[i]
				var PsiID=Psiarry.split("^")[0]
				var PisTesItmArr = $("input[name=TestItem]");
	    		for (var j=0; j < PisTesItmArr.length; j++){
		    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
			    		}
		    		}
				}
		}
	}
	function OtherInfo(){
		var mPisTesDiagArr=[]; var mPisTesDiag="";
		var TesDiagArr = $("input[name=TestItem]");
		for (var j=0; j < TesDiagArr.length; j++){
		    if($("[value='"+TesDiagArr[j].value+"'][name=TestItem]").is(':checked')){
				mPisTesDiagArr.push(TesDiagArr[j].value);
		    }
		}
		var mCureSelect = JSON.stringify(mPisTesDiagArr);
		var rtnObj = {}
		rtnObj["mPisTestItem"] = mCureSelect;
		return rtnObj
	}
	function PrintInfo(){
		var FixItem=""
		var TesDiagArr = $("input[name=TestItem]");
		for (var j=0; j < TesDiagArr.length; j++){
		    if($("[value='"+TesDiagArr[j].value+"'][name=TestItem]").is(':checked')){
				if (FixItem==""){
					FixItem=$('#'+TesDiagArr[j].id).parent().next().text() 
					}else{
					FixItem=FixItem+","+$('#'+TesDiagArr[j].id).parent().next().text() 
					}
		    }
		}
		var rtnObj = {}
		rtnObj["PisTestItem"] = FixItem;
		return rtnObj	
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();
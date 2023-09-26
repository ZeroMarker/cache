var FFKPanel=(function(){
	function Init(){
		LoadTestItemList();
		LoadOtherInfo();
		}
	/// 加载HPV病人病历内容
	function LoadTestItemList(){
		
		/// 初始化检查方法区域
		$("#TesItem").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonPatRecList",{"HospID":LgHospID},function(jsonString){

			if (jsonString != ""){
				var jsonObjArr = jsonString;
				for (var i=0; i<jsonObjArr.length; i++){
					InsTesItemRegion(jsonObjArr[i]);
				}
			}
		},'json',false)
	}

	/// HPV病人病历内容
	function InsTesItemRegion(itemobj){	
		/// 标题行
		var htmlstr = '';
		/// 注释标题行 qunianpeng 2018/1/30
		htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';

		/// 项目
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
		$("#TesItem").append(htmlstr+itemhtmlstr)
	}
	function LoadOtherInfo(){
		var OtherInfo=""
		if (itemReqJsonStr!=""){
			for (var i = 0; i < itemReqJsonStr.length; i++) {
				var OneReqJson=itemReqJsonStr[i]
				var ID=OneReqJson.ID
				var Val=OneReqJson.Val
				if (ID="OtherInfo") OtherInfo=Val
			}
		}
		if (OtherInfo!=""){
			OtherObj=$.parseJSON(OtherInfo); 
			mPisTesItm=$.parseJSON(OtherObj["mPisPatRec"])
			for (var i = 0; i < mPisTesItm.length; i++) {
				var Psiarry=mPisTesItm[i]
				var PsiID=Psiarry.split("^")[0]
				var PisTesItmArr = $("input[name=PatRec]");
	    		for (var j=0; j < PisTesItmArr.length; j++){
		    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
			    		}
		    		}
				}
			mPisTesItm=$.parseJSON(OtherObj["mPisTesDiag"])
			for (var i = 0; i < mPisTesItm.length; i++) {
				var Psiarry=mPisTesItm[i]
				var PsiID=Psiarry.split("^")[0]
				var PisTesItmArr = $("input[name=TesDiag]");
	    		for (var j=0; j < PisTesItmArr.length; j++){
		    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
			    		}
		    		}
				}
			mPisTesItm=$.parseJSON(OtherObj["mCureSelect"])
			for (var i = 0; i < mPisTesItm.length; i++) {
				var Psiarry=mPisTesItm[i]
				var PsiID=Psiarry.split("^")[0]
				var PisTesItmArr = $("input[name=CureSelect]");
	    		for (var j=0; j < PisTesItmArr.length; j++){
		    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
			    		}
		    		}
				}
			$("#recLoc").combobox("setText",OtherObj["RecLocDesc"]);
			}
		}
	function OtherInfo(){
		/// 病人病历
		var mPisPatRec=""; mPisPatRecArr = [];
	    var PatRecArr = $("input[name=PatRec]");
	    for (var j=0; j < PatRecArr.length; j++){
		    if($('#'+PatRecArr[j].id).is(':checked')){
				mPisPatRecArr.push(PatRecArr[j].value);
		    }
		}
		var mPisPatRec = JSON.stringify(mPisPatRecArr);
		/// 临床诊断
		var mPisTesDiagArr=[]; var mPisTesDiag="";
		var TesDiagArr = $("input[name=TesDiag]");
		for (var j=0; j < TesDiagArr.length; j++){
		    if($("[value='"+TesDiagArr[j].value+"'][name=TesDiag]").is(':checked')){
				mPisTesDiagArr.push(TesDiagArr[j].value);
		    }
		}
		var mPisTesDiag = JSON.stringify(mPisTesDiagArr);
		/// 临床诊断
		var mPisTesDiagArr=[]; var mPisTesDiag="";
		var TesDiagArr = $("input[name=CureSelect]");
		for (var j=0; j < TesDiagArr.length; j++){
		    if($("[value='"+TesDiagArr[j].value+"'][name=CureSelect]").is(':checked')){
				mPisTesDiagArr.push(TesDiagArr[j].value);
		    }
		}
		var mCureSelect = JSON.stringify(mPisTesDiagArr);
		var rtnObj = {}
		rtnObj["mPisPatRec"] = mPisPatRec;
		rtnObj["mPisTesDiag"] = mPisTesDiag;
		rtnObj["mCureSelect"] = mCureSelect;
		rtnObj["PisReqSpec"] = 1+"#"+"宫颈脱落细胞" +"#"+ 1 +"#"+ "" + +"#"+ 1+ "#"+ "";
		return rtnObj
		}
	function PrintInfo(){
		return ""
		}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
		}
	   
})();
var MOPPanel=(function(){
	function Init(){
		LoadTestItemList();       /// 加载HPV病人病历内容
		LoadCutBaseList();        /// 加载取材分类内容
		InitPageCheckBox();       /// 页面CheckBox控制
		LoadPatClinicalRec();
		LoadOtherInfo();
		}
	/// 加载检测项目内容
	function LoadTestItemList(){
		
		/// 初始化检查方法区域
		$("#TesItem").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
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
			htmlstr = '<tr style="height:30px"><td colspan="7" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ Subitemobj.text +'</td></tr>';
		 itemhtmlstr = "";
		for (var jj=0; jj<Subitemobj.items.length; jj++){
			var itemobj=Subitemobj.items[jj]
			itemhtmlstr=itemhtmlstr+'<tr style="height:30px"><td colspan="7" class=" " style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';
			var itemArr = itemobj.items;
			var itemhtmlArr = [];
			for (var j=1; j<=itemArr.length; j++){
				
				itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
				if (j % 3 == 0){
					itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '</tr>';
					itemhtmlArr = [];
				}
			}
			if ((j-1) % 3 != 0){
				itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
				itemhtmlArr = [];
			}
		}
		$("#TesItem").append(htmlstr+itemhtmlstr)
	}
	/// 加载取材分类内容
	function LoadCutBaseList(){
		
		/// 初始化取材分类区域
		$("#CutBas").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonGetPisCutBasList",{"HospID":LgHospID},function(jsonString){

			if (jsonString != ""){
				var jsonObjArr = jsonString;
				for (var i=0; i<jsonObjArr.length; i++){
					InsCutBaseRegion(jsonObjArr[i]);
				}
			}
		},'json',false)
	}

	/// 检测取材分类内容
	function InsCutBaseRegion(itemobj){	
		/// 标题行
		var htmlstr = '';
			htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;">'+ itemobj.text +'</td></tr>';

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
		$("#CutBas").append(htmlstr+itemhtmlstr)
	}
	/// 页面CheckBox控制
	function InitPageCheckBox(){
		
		$("input[name=CutBas]").click(function(){
			
			if($("[value='"+this.id+"'][name=CutBas]").is(':checked')){
				$("input[name=CutBas]:not([value='"+this.id+"'])").removeAttr("checked");
			}
		});
		
	}
	/// 加载临床病历 
	function LoadPatClinicalRec(){
		runClassMethod("web.DHCAppPisMasterQuery","GetPatClinicalRec",{"EpisodeID":EpisodeID},function(jsonString){

			if (jsonString != null){
				var jsonObjArr = jsonString;
			
				$("#MedRecord").val( jsonObjArr.arExaReqSym +""+ jsonObjArr.arExaReqHis +""+ jsonObjArr.arExaReqSig);  /// 主诉+现病史+体征
				
			}
		},'json',false)
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
			mType=$.parseJSON(OtherObj["mType"])
			$("[value='"+mType+"'][name=CutBas]").attr("checked",true);
			}
	}
	function OtherInfo(){
		var mType="";										   /// 取材类型
	    var mTypeArr = $("input[name=CutBas]");
	    for (var j=0; j < mTypeArr.length; j++){
		    if($("[value='"+mTypeArr[j].value+"'][name=CutBas]").is(':checked')){
				mType = mTypeArr[j].value;
		    }
		}
		var mType = JSON.stringify(mType);
		var mPisTestItem=""; mPisTestItemArr = [];
	    var TestItemArr = $("input[name=TestItem]");
	    for (var j=0; j < TestItemArr.length; j++){
		    if($("[value='"+TestItemArr[j].value+"'][name=TestItem]").is(':checked')){
				mPisTestItemArr.push(TestItemArr[j].value);
		    }
		}
		var mPisTestItem = JSON.stringify(mPisTestItemArr);
		var rtnObj = {}
		rtnObj["mType"] = mType;
		rtnObj["mPisTestItem"] = mPisTestItem;
		rtnObj["PisReqSpec"] = 1+"#"+$("#Position").val() +"#"+ 1 +"#"+ "" + +"#"+ 1+ "#"+ "";;
		return rtnObj;
		}
	function PrintInfo(){
		var PisTesItmMol=""
		var TestItemArr = $("input[name=TestItem]");
	    for (var j=0; j < TestItemArr.length; j++){
		    if($("[value='"+TestItemArr[j].value+"'][name=TestItem]").is(':checked')){
				if (PisTesItmMol==""){PisTesItmMol=$('#'+TestItemArr[j].id).parent().next().text()
				}else{PisTesItmMol=PisTesItmMol+","+$('#'+TestItemArr[j].id).parent().next().text()}
		    }
		}
		var rtnObj = {}
		rtnObj["PisTesItmMol"] = PisTesItmMol;
		return rtnObj;
		}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
		}
	   
})();
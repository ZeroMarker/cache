var HPVSJPanel=(function(){
	function Init(){
		LoadSpecItemList();
		InitPageCheckBox();
		LoadOtherInfo();
	}
	/// 加载标本内容
	function LoadSpecItemList(){
		
		/// 初始化标本内容区域
		$("#itemPisSpec").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonGetPisSpecList",{"HospID":LgHospID},function(jsonString){

			if (jsonString != ""){
				var jsonObjArr = jsonString;
				for (var i=0; i<jsonObjArr.length; i++){
					InitSpecItemRegion(jsonObjArr[i]);
				}
			}
		},'json',false)
	}

	/// 标本内容
	function InitSpecItemRegion(itemobj){	
		/// 标题行
		var htmlstr = '';
			//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;">'+ itemobj.text +'</td></tr>';

		/// 项目
		var itemArr = itemobj.items;
		var itemhtmlArr = []; itemhtmlstr = "";
		for (var j=1; j<=itemArr.length; j++){
			
			var MulFlag = itemArr[j-1].name.indexOf("Y") != "-1"?"Y":"N";
			var InputHtml = '<input type="text" class="name-input" id="Spec'+ itemArr[j-1].value +'" value="1" name="'+ MulFlag +'"></input>';
			itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text + InputHtml +'</td>');
			if (j % 4 == 0){
				itemhtmlstr = itemhtmlstr + '<tr style="height:40px;">' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}
		}
		if ((j-1) % 4 != 0){
			itemhtmlstr = itemhtmlstr + '<tr style="height:40px;">' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
			itemhtmlArr = [];
		}
		$("#itemPisSpec").append(htmlstr+itemhtmlstr)
	}
	/// 页面CheckBox控制
	function InitPageCheckBox(){

		$("input[name^=PisSpec]").click(function(){
			
			if($("[value='"+this.id+"'][name^=PisSpec]").is(':checked')){
				/// 选中
				$("#Spec"+ this.id).show();
				//$("input[name=PisSpec]:not([value='"+this.id+"'])").removeAttr("checked");
				//$("[id^=Spec][id!='Spec"+this.id+"']").hide();
				if (this.name.indexOf("Y") == "-1"){
					$("input[name^=PisSpec]:not([value='"+this.value+"'])").removeAttr("checked");
					$("[id^=Spec][id!='Spec"+this.value+"']").hide();
				}else{
					$("input[name^=PisSpec]:not([value='"+this.value+"']):not([name$=Y])").removeAttr("checked");
					$("[id^=Spec][id!='Spec"+this.value+"']:not([name$='Y'])").hide();
				}
			}else{
				/// 取消
				$("#Spec"+ this.id).hide();
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
			if (OtherObj["mPisPatSpecinfo"]){
				mPisPatSpec=$.parseJSON(OtherObj["mPisPatSpecinfo"])
				for (var i = 0; i < mPisPatSpec.length; i++) {
						var PatSpecArry=mPisPatSpec[i].split("^")
						$("[value='"+PatSpecArry[1]+"'][name^=PisSpec]").attr("checked",true);
						$("#Spec"+ PatSpecArry[1]).show();
						$("#Spec"+ PatSpecArry[1]).val(PatSpecArry[4]);
						}
				}
			}
		}
	function OtherInfo(){
		/// 病理标本
		var mPisPatSpec=""; PisPatSpecArr = [];
	    var PatSpecArr = $("input[name^=PisSpec]");
	    var i = 1;
	    var PisReqSpec=""
	    for (var j=0; j < PatSpecArr.length; j++){
		    if($("[value='"+PatSpecArr[j].value+"'][name^=PisSpec]").is(':checked')){
			    /// 标本名称
			    var PisSpecDesc = $("[value='"+PatSpecArr[j].value+"'][name^=PisSpec]").parent().next().text();
				var Qty = $("#Spec"+ PatSpecArr[j].value).val();
				PisPatSpecArr.push((i++) +"^"+ PatSpecArr[j].value +"^"+ PisSpecDesc +"^^"+ Qty);
				if (PisReqSpec==""){
					PisReqSpec = j+"#"+PisSpecDesc +"#"+ Qty +"#"+ "" + +"#"+ j+ "#"+ "";
				}else{
					PisReqSpec = PisReqSpec+"@"+j+"#"+PisSpecDesc +"#"+ Qty +"#"+ "" + +"#"+ j+ "#"+ "";	
				}
		    }
		}
		mPisPatSpec=JSON.stringify(PisPatSpecArr);
		var rtnObj = {}
		rtnObj["mPisPatSpecinfo"] = mPisPatSpec;
		rtnObj["PisReqSpec"] = PisReqSpec;
		return rtnObj
		}
	function PrintInfo(){
		/// 病理标本
		var mPisPatSpec=""; PisPatSpecArr = [];
		var PisReqSpec=""
	    var PatSpecArr = $("input[name^=PisSpec]");
	    var i = 1;
	    for (var j=0; j < PatSpecArr.length; j++){
		    if($("[value='"+PatSpecArr[j].value+"'][name^=PisSpec]").is(':checked')){
			    /// 标本名称
			    var PisSpecDesc = $("[value='"+PatSpecArr[j].value+"'][name^=PisSpec]").parent().next().text();
				var Qty = $("#Spec"+ PatSpecArr[j].value).val();
				PisPatSpecArr.push((i++) +"^"+ PatSpecArr[j].value +"^"+ PisSpecDesc +"^^"+ Qty);
				if (PisReqSpec==""){
					PisReqSpec = PisSpecDesc +" "+ Qty ;
				}else{
					PisReqSpec = PisReqSpec+","+PisSpecDesc +" "+ Qty ;	
				}
		    }
		}
		var rtnObj = {}
		rtnObj["PisReqSpec"] = PisReqSpec;
		return rtnObj
		}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
		}
	   
})();
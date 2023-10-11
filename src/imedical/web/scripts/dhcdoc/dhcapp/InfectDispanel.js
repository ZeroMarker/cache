var InfectDispanel=(function(){
	function Init(){
		LoadTestItemList();
		InitPageCheckBox();
		LoadOtherInfo();
	}
	function LoadTestItemList(){
		
		/// 初始化检查方法区域
		$("#InfectDis").html('<tr style="height:0px;" ><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td><td style="width:30px;"></td><td></td></tr>');
		//runClassMethod("web.DHCAppPisMasterQuery","JsonInfectDis",{"HospID":LgHospID},function(jsonString){
		runClassMethod("web.DHCAppPisMasterQuery","JsonBaseItemList",{"Title":"传染病史", "Name":"InfectDis", "Type":MapCode,"HospID":LgHospID},function(jsonString){

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
			Title:"传染病史",
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
			   InputHtml = '<input type="text" class="name-input-80" id="Infect'+ itemArr[j-1].value +'"></input>';
			}
			if (j % 4 == 0){
				itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" class="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td style="border-right:none;">'+ itemArr[j-1].text + InputHtml +'</td>');
				itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}else{
				itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" class="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td >'+ itemArr[j-1].text + InputHtml +'</td>');
				}
		}
		if ((j-1) % 4 != 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td style="border-right:none;"></td></tr>';
			itemhtmlArr = [];
		}
		$("#InfectDis").append(htmlstr+itemhtmlstr)
	}
	/// 页面CheckBox控制
	function InitPageCheckBox(){
		
		$("input[name=InfectDis]").click(function(){
			if ($(this).parent().next().text() == "其他"){
				if($("[value='"+this.id+"'][name=InfectDis]").is(':checked')){
					/// 选中
					$("#Infect"+ this.id).show();
				}else{
					/// 取消
					$("#Infect"+ this.id).hide();
				}
			}
		
			/// 选择无时，进行设置
			if (($(this).parent().next().text() == "无")||($(this).parent().next().text() == "未做传染性相关检查")||($(this).parent().next().text() == "结果未回")){
				if($("[value='"+this.id+"'][name=InfectDis]").is(':checked')){
					$("input[name=InfectDis][value!='"+this.id+"']").removeAttr("checked");
					/// 取消
					//$("[id^='Infect']").hide();
				}
			}else{
				$("input[name=InfectDis]").each(function(){
					if (($(this).parent().next().text() == "无")||($(this).parent().next().text() == "未做传染性相关检查")||($(this).parent().next().text() == "结果未回")){
						$("input[name=InfectDis][value='"+this.id+"']").removeAttr("checked");
					}
				});
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
			if (OtherObj["mPisTesItmArr"]) {
				mPisTesItm=$.parseJSON(OtherObj["mPisTesItmArr"])
				for (var i = 0; i < mPisTesItm.length; i++) {
					var Psiarry=mPisTesItm[i]
					var PsiID=Psiarry.split("^")[0]
					var PisTesItmArr = $("input[name=InfectDis]");
		    		for (var j=0; j < PisTesItmArr.length; j++){
			    		if (PisTesItmArr[j].id==PsiID){
								$('#'+PsiID).attr("checked",true);
								if ($('#'+PsiID).parent().next().text() == "其他"){
									$("#Infect"+ PsiID).show();
									$("#Infect"+ PsiID).val(Psiarry.split("^")[1]);
								}
				    		}
			    		}
					}
				}
			}
		}
	function OtherInfo(){
		mPisTesItmArr = []
		var PisTesItmArr = $("input[name=InfectDis]");
	    for (var j=0; j < PisTesItmArr.length; j++){
		    if($('#'+PisTesItmArr[j].id).is(':checked')){
			    /// 其他项目判断
			    var TestItem = "";
			    if ($('#'+PisTesItmArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#Infect"+ PisTesItmArr[j].id).val();
					if (TestItem == "") {mPisTesFlag=1; break;}
				}
				
				mPisTesItmArr.push(PisTesItmArr[j].value +"^"+ TestItem);
		    }
		}
		var mPisTesItm = JSON.stringify(mPisTesItmArr);
		mPisTesItmArr = []
		var rtnObj = {}
		rtnObj["mPisTesItmArr"] = mPisTesItm;
		return rtnObj
	}
	function PrintInfo(){
		var mPisTesItm=""
		var PisTesItmArr = $("input[name=InfectDis]");
	    for (var j=0; j < PisTesItmArr.length; j++){
		    if($('#'+PisTesItmArr[j].id).is(':checked')){
			    /// 其他项目判断
			    var TestItem = "";
			    if ($('#'+PisTesItmArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#Infect"+ PisTesItmArr[j].id).val();
					
				}else{
					TestItem=$('#'+PisTesItmArr[j].id).parent().next().text() 
					if ((TestItem!="无")&&(TestItem!="未做传染性相关检查")&&(TestItem!="结果未回")){
						TestItem=TestItem+"(+)"
						}
					}
				if (mPisTesItm==""){
					var OnePic
					mPisTesItm=TestItem 
					}else{
					mPisTesItm=mPisTesItm+","+TestItem 
					}
				
		    }
		}
		var rtnObj = {}	
		rtnObj["PisPatInfDis"] = mPisTesItm;	
		return rtnObj
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();
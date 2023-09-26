var PisSpecpanel=(function(){
	function Init(){
		LoadSpecItemList("");       /// 加载标本内容
		LoadOtherInfo();
	}
	/// 加载标本内容
	function LoadSpecItemList(Arcim){
		if ((ARCIM!="")&&(Arcim=="")){Arcim=ARCIM}
		/// 初始化标本内容区域
		$("#itemPisSpec").html('<tr style="height:0px;"><td style="width:20px;"></td><td style="width:200px;" ></td><td style="width:20px;"></td><td style="width:200px;"></td><td style="width:20px;"></td><td style="width:200px;"></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonGetPisSpecList",{"HospID":LgHospID,"Arcim":Arcim},function(jsonString){

			if (jsonString != ""){
				var jsonObjArr = jsonString;
				for (var i=0; i<jsonObjArr.length; i++){
					InitSpecItemRegion(jsonObjArr[i]);
				}
			}
		},'json',false)
	}
	function InitSpecItemRegion(itemobj){	
		/// 标题行
		var htmlstr = '';
			//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;">'+ itemobj.text +'</td></tr>';

		/// 项目
		var itemArr = itemobj.items;
		var itemhtmlArr = []; itemhtmlstr = "";
		for (var j=1; j<=itemArr.length; j++){
			
			var MulFlag = itemArr[j-1].name.indexOf("Y") != "-1"?"Y":"N";
			var CellFlag=itemArr[j-1].InsertCell
			if (CellFlag=="Y"){
				var InputHtml = '<div id="sub'+ itemArr[j-1].value +'" class="name-input" >部位:<input type="text" style="width:100px" id="Spec'+ itemArr[j-1].value +'" value="" ></div>';	
			}else{
			
			var InputHtml = '<input type="text" class="name-input" style="width:100px" id="Spec'+ itemArr[j-1].value +'" value="1" name="'+ MulFlag +'"></input>';
			
			}
			itemhtmlArr.push('<td style="width:30px;"><input name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text + InputHtml +'</td>');
			if (j % 3 == 0){
				itemhtmlstr = itemhtmlstr + '<tr style="height:40px;">' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}
		}
		if ((j-1) % 3 != 0){
			itemhtmlstr = itemhtmlstr + '<tr style="height:40px;">' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
			itemhtmlArr = [];
		}
		$("#itemPisSpec").append(htmlstr+itemhtmlstr)
		InitPageCheckBox();
		LoadOtherInfo();
	}
	function InitPageCheckBox(){
		$("input[name^=PisSpec]").click(function(){
			if (ServerObj.CheckSpecEditor=="1") {
				$("input[name=PisSpec][value='"+this.id+"']").removeAttr("checked");
				return;
			}
			if($("[value='"+this.value+"'][name^=PisSpec]").is(':checked')){
				/// 选中
				$("#Spec"+ this.value).show();
				$("#sub"+ this.value).show();
				if (this.name.indexOf("Y") == "-1"){
					$("input[name^=PisSpec]:not([value='"+this.value+"'])").removeAttr("checked");
					$("[id^=Spec][id!='Spec"+this.value+"']").hide();
					$("[id^=sub][id!='sub"+this.value+"']").hide();
				}else{
					$("input[name^=PisSpec]:not([value='"+this.value+"']):not([name$=Y])").removeAttr("checked");
					$("[id^=Spec][id!='Spec"+this.value+"']:not([name$='Y'])").hide();
					$("[id^=sub][id!='sub"+this.value+"']:not([name$='Y'])").hide();
				}
				$("#sub"+ this.value).css("display","inline-block");
				/*$('#LocID'+ this.value).combobox({	
					mode:'remote',  
					url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID,
					blurValidValue:true,
					onShowPanel:function(){
						// var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID;
						// $("#LocID").combobox('reload',unitUrl);
					},
					onSelect:function(){	
						
					}
				});
				$('#LocID'+ this.value).combobox("setValue",session['LOGON.CTLOCID']);*/
				//$("#sub"+ this.value).css("display","inline-block");
			}else{
				/// 取消
				$("#Spec"+ this.value).hide();
				$("#sub"+ this.value).hide();
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
			if (OtherObj["mPisPatSpecinfo"]) {
				mPisPatSpec=$.parseJSON(OtherObj["mPisPatSpecinfo"])
				for (var i = 0; i < mPisPatSpec.length; i++) {
					var PatSpecArry=mPisPatSpec[i].split("^")
					$("[value='"+PatSpecArry[1]+"'][name^=PisSpec]").attr("checked",true);
					$("#Spec"+ PatSpecArry[1]).show();
					$("#Spec"+ PatSpecArry[1]).val(PatSpecArry[4]);
					$("#sub"+ PatSpecArry[1]).show();
					$("#sub"+ PatSpecArry[1]).css("display","inline-block");
				}
			}
		}
		if ((PisID!="")&&(EpisodeID!="")){
			ServerObj.CheckSpecEditor=$.cm({
			    ClassName : "DHCDoc.DHCApp.BasicConfig",
			    MethodName : "CheckSpecEditor",
			    dataType:"text",
			    "PisID":PisID,
			    "EpisodeID":EpisodeID
		    },false);
		}
		if (ServerObj.CheckSpecEditor=="0"){ 
			setTimeout(function(){ 
				$("input[name^=PisSpec]").attr("disabled", false); 
				$("input[id^=Spec]").attr("disabled", false); 
			}, 1000);
		}
		}
	function OtherInfo(){
		/// 病理标本
		var mPisPatSpec=""; PisPatSpecArr = [];
		var PisReqSpec=""
	    var PatSpecArr = $("input[name^=PisSpec]");
	    var i = 1;
	    for (var j=0; j < PatSpecArr.length; j++){
		    if($("[value='"+PatSpecArr[j].value+"'][name^=PisSpec]").is(':checked')){
			    /// 标本名称
			    var PisSpecDesc = $("[value='"+PatSpecArr[j].value+"'][name^=PisSpec]").parent().next().text();
			    if (PisSpecDesc.indexOf("部位")>=0){
				    PisSpecDesc=PisSpecDesc.split("部位")[0]
				    }
				var Qty = $("#Spec"+ PatSpecArr[j].value).val();
				PisPatSpecArr.push((i++) +"^"+ PatSpecArr[j].value +"^"+ PisSpecDesc +"^^"+ Qty);
				if (PisReqSpec==""){
					PisReqSpec = j+"#"+PisSpecDesc +"#"+ Qty +"#"+ "" + "#"+ j+ "#"+ "";
				}else{
					PisReqSpec = PisReqSpec+"@"+j+"#"+PisSpecDesc +"#"+ Qty +"#"+ "" +"#"+ j+ "#"+ "";	
				}
		    }
		}
		var mPisPatSpec = JSON.stringify(PisPatSpecArr);
		var rtnObj = {}
		rtnObj["PisReqSpec"] = PisReqSpec;
		rtnObj["mPisPatSpecinfo"] = mPisPatSpec;
		return rtnObj
		}
	function PrintInfo(){
		/// 病理标本
		var mPisPatSpec=""; PisPatSpecArr = [];
		var PisSpecDesc=""
	    var PatSpecArr = $("input[name^=PisSpec]");
	    var i = 1;
	    for (var j=0; j < PatSpecArr.length; j++){
		    if($("[value='"+PatSpecArr[j].value+"'][name^=PisSpec]").is(':checked')){
			    /// 标本名称
			    var PisSpecDesc = $("[value='"+PatSpecArr[j].value+"'][name^=PisSpec]").parent().next().text();
			   	var PartDesc=""
			    if (PisSpecDesc.indexOf("部位")>=0){
				    PisSpecDesc=PisSpecDesc.split("部位")[0]
				    var PartDesc = $("#Spec"+ PatSpecArr[j].value).val();
				    }else{
					var Qty = $("#Spec"+ PatSpecArr[j].value).val();
				    }
		    }
		}
		var rtnObj = {}
		rtnObj["PisReqSpec"] = PisSpecDesc;
		rtnObj["PartDesc"] = PartDesc;
		rtnObj["Qty"] = Qty;
		return rtnObj
		}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
		"LoadSpecItemList":LoadSpecItemList,
		}
	   
})();
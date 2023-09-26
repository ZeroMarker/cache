var BBPanel=(function(){
	function Init(){
		InitPageComponent()
		LoadTestItemList();       /// 加载HPV病人病历内容
		LoadSpecItemList();       /// 加载标本内容
		LoadPatClinicalRec();	  /// 加载临床病历
		InitPageCheckBox();
		LoadOtherInfo();
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
			mPisPatSpec=$.parseJSON(OtherObj["mPisPatSpec"])
			for (var i = 0; i < mPisPatSpec.length; i++) {
				var PatSpecArry=mPisPatSpec[i].split("^")
				$("[value='"+PatSpecArry[1]+"'][name^=PisSpec]").attr("checked",true);
				$("#Spec"+ PatSpecArry[1]).show();
				$("#Spec"+ PatSpecArry[1]).val(PatSpecArry[4]);
			}
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
			if (OtherObj["fixActive"]) {
				fixActive=$.parseJSON(OtherObj["fixActive"])
				$('#'+fixActive).attr("checked",true);
			}
		}
	}
	/// 初始化界面控件内容
	function InitPageComponent(){
			
		// 既往手术史增加无选项及切换效果 qunianpeng 2018/8/28
		$("#PrevHisFlag1").on('click',function(){			
			if($("#"+this.id).is(':checked')){
				$("#PrevHisFlag2").removeAttr("checked");
				$("#PrevContent").css('display','block');
			};			
		})
		$("#PrevHisFlag2").on('click',function(){			
			if($("#"+this.id).is(':checked')){
				$("#PrevHisFlag1").removeAttr("checked");
				$("#PrevContent").css('display','none');
			};			
		})
	}
	/// 加载病人传染病史内容
	function LoadTestItemList(){
		
		/// 初始化检查方法区域
		$("#TesItem").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonPatInfDisList",{"HospID":LgHospID},function(jsonString){

			if (jsonString != ""){
				var jsonObjArr = jsonString;
				for (var i=0; i<jsonObjArr.length; i++){
					InsTesItemRegion(jsonObjArr[i]);
				}
			}
		},'json',false)
	}

	/// 病人传染病史内容
	function InsTesItemRegion(itemobj){	
		/// 标题行
		var htmlstr = '';
			htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';

		/// 项目
		var itemArr = itemobj.items;
		var itemhtmlArr = []; itemhtmlstr = "";
		for (var j=1; j<=itemArr.length; j++){
			
			var InputHtml = "";
			if (itemArr[j-1].text == "其他"){
			   InputHtml = '<input type="text" class="name-input-80" id="Test'+ itemArr[j-1].value +'"></input>';
			}
			type="checkbox";
			if(itemArr[j-1].name=="FixItem"){
				type="radio";
			}
			itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="'+type+'" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text + InputHtml +'</td>');
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
	/// 加载标本内容
	function LoadSpecItemList(){
		
		/// 初始化标本内容区域
		$("#itemPisSpec").html('<tr style="height:0px;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonGetPisSpecList",{"HospID":LgHospID},function(jsonString){

			if (jsonString != ""){
				var jsonObjArr = jsonString;
				for (var i=0; i<jsonObjArr.length; i++){
					InitSpecItemRegion(jsonObjArr[i]);
				}
			}
		},'json',false)
	}
	/// 加载临床病历  sufan 2018-02-01
	function LoadPatClinicalRec(){
		runClassMethod("web.DHCAppPisMasterQuery","GetPatClinicalRec",{"EpisodeID":EpisodeID},function(jsonString){

			if (jsonString != null){
				var jsonObjArr = jsonString;
			
				$("#MedRecord").val( jsonObjArr.arExaReqSym +""+ jsonObjArr.arExaReqHis +""+ jsonObjArr.arExaReqSig);  /// 主诉+现病史+体征
				
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
			var CellFlag=itemArr[j-1].InsertCell
			if (CellFlag=="Y"){
				var InputHtml = '<div id="sub'+ itemArr[j-1].value +'" class="name-input" >部位:<input type="text" style="width:30px" id="Spec'+ itemArr[j-1].value +'" value="" >科室:</input><input id="LocID'+itemArr[j-1].value +'" class="textbox" style="width:100px;" data-options=""/></div>';	
			}else{
			
			var InputHtml = '<input type="text" class="name-input" id="Spec'+ itemArr[j-1].value +'" value="1" name="'+ MulFlag +'"></input>';
			
			}
			itemhtmlArr.push('<td style="width:430px;"><input name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text + InputHtml +'</td>');
			if (j % 3 == 0){
				itemhtmlstr = itemhtmlstr + '<tr style="height:40px;">' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}
		}
		if ((j-1) % 3 != 0){
			itemhtmlstr = itemhtmlstr + '<tr style="height:40px;">' + itemhtmlArr.join("") + '<td style="width:180px"></td><td></td></tr>';
			itemhtmlArr = [];
		}
		$("#itemPisSpec").append(htmlstr+itemhtmlstr)
	}
	/// 页面CheckBox控制
	function InitPageCheckBox(){
		
		$("input[name^=PisSpec]").click(function(){
			
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
				$('#LocID'+ this.value).combobox({	
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
				$('#LocID'+ this.value).combobox("setValue",session['LOGON.CTLOCID']);
				$("#sub"+ this.value).css("display","inline-block");
			}else{
				/// 取消
				$("#Spec"+ this.value).hide();
				$("#sub"+ this.value).hide();
			}
		});
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
				var Qty = $("#Spec"+ PatSpecArr[j].value).val();
				PisPatSpecArr.push((i++) +"^"+ PatSpecArr[j].value +"^"+ PisSpecDesc +"^^"+ Qty);
				if (PisReqSpec==""){
					PisReqSpec = j+"#"+PisSpecDesc +"#"+ Qty +"#"+ "" + +"#"+ j+ "#"+ "";
				}else{
					PisReqSpec = PisReqSpec+"@"+j+"#"+PisSpecDesc +"#"+ Qty +"#"+ "" + +"#"+ j+ "#"+ "";	
				}
		    }
		}
		var mPisPatSpec = JSON.stringify(PisPatSpecArr);
		/// 传染病史
		var mPisTestItem=""; mPisTesItmArr = []; mPisTesFlag = 0;
	    var PisTesItmArr = $("input[name=TestItem]");
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
		var mPisTestItem = JSON.stringify(mPisTesItmArr);
		//固定方式
		var fixActive=""
		if($("input[name^=FixItem]:checked").length>0){
			fixActive=$("input[name^=FixItem]:checked")[0].value
		}
		var rtnObj = {}
		rtnObj["mPisPatSpec"] = mPisPatSpec;
		rtnObj["mPisTestItem"] = mPisTestItem;
		rtnObj["fixActive"] = fixActive;
		rtnObj["PisReqSpec"] = PisReqSpec;
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
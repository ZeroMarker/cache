if (websys_isIE==true) {
     var script = document.createElement('script');
     script.type = 'text/javaScript';
     script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
     document.getElementsByTagName('head')[0].appendChild(script);
}
var LastHiddernStr="";
window.onload = function(){ 
	var valbox = $HUI.panel("#ItemListTitle",{
		title:MapDesc,
	});
	if (DocMainFlag == 1){
		if (typeof EmgFlag =="undefined"){EmgFlag="";}
		if (typeof EmgId =="undefined"){EmgId="";}
		if ((EmgFlag=="Y")&&(EmgId!="")) {
			$("#"+EmgId).prop('checked',true);
		}
	}
	$(window).resize(function() {
		setTimeout(function() { 
        	$(".hisui-panel").panel('resize',{width:'100%'});
        }, 250);
	})
} 

$(function(){
	
	//初始化
	//BLInit();
	if (BLIDStr!=""){
		var BLIDStrArry=BLIDStr.split("^")
		for (var i = 0; i < BLIDStrArry.length; i++) {
			var Obj=eval(BLIDStrArry[i]) 
			Obj.Init()
		}
	}
	//初始化医嘱表格
	InitVersionMain();
	//缓存加载数据
	storageAllCache();
	//tPanel.Init()
	if (ServerObj.BLInit=="Y"){
		Init()
		if (PisNo!=""){$("#PisNo").text(PisNo);}
		if (oeori!=""){$("#Oeori").text(oeori);}
		if (ARCIM!=""){$("#TesItemID").val(ARCIM);}
	}
	//加载已经保存的申请单数据
	LoaditemReqJsonStr()
	//加载其他信息
	if (ServerObj.BLLoadOther=="Y"){
		LoadOtherInfo(itemReqJsonStr)
	}
	//控制按钮
	ConTroClick()
	//加载必填项
	addclsRequired()
	//翻译
	TransLate()
	if (Oeori != ""){
		$('#ItemListTitle').panel({closed:true}); 
		//$('a:contains("发送")').hide();
		if (ARCIM!=""){
			ItemMastOn(ARCIM,ARCIMDesc,"")
		}
	}
})
function TransLate(){
	var MapIDStrArr=BLIDStr.split("^")
	for (var i = 0; i < MapIDStrArr.length; i++) {
		var OneMapID=MapIDStrArr[i]
		var rtnObj = {}
		var arrayObj = new Array(
	      new Array(".textbox"),
		  new Array(".hisui-datetimebox"),
		  new Array(".hisui-checkbox"),
		  new Array(".checkbox"),
		  new Array(".hisui-validatebox"),
		  new Array(".tanslate")
		);
		for( var j=0;j<arrayObj.length;j++) {
		var domSelector=arrayObj[j][0]
		var $nodes=$("#"+OneMapID).find(domSelector)
		for (var ijj=0; ijj< $nodes.length; ijj++){
				var domId = $nodes[ijj]['id']||"";
				if (domId == "") {
					continue;
				}
				var componentType = "" //getComponentType(domId)
				var isJump = ""  //supportJump(componentType);
				var domName = "";
				var _$label = $("label[for="+domId+"]");
				if (_$label.length > 0){
				   domName = _$label[0].innerHTML;
				    _$label[0].innerHTML=$g(domName);
				}
			}
	}
	}
}
function storageAllCache(){
	if (CacheMapRowIDStr!=""){
		var MapStrArry=CacheMapRowIDStr.split("^")
		var MapIDStrArr=CacheMapIDStr.split("^")
		for (var i = 0; i < MapIDStrArr.length; i++) {
			var OneMapID=MapIDStrArr[i]
			var OneMapRowID=MapStrArry[i]
			storageOneCache(OneMapID,OneMapRowID)
		}
	}
}
function storageOneCache(OneMapID,OneMapRowID){
	var rtnObj = {}
	var arrayObj = new Array(
      new Array(".textbox"),
	  new Array(".hisui-datetimebox"),
	  new Array(".hisui-checkbox")
	);
	for( var j=0;j<arrayObj.length;j++) {
		var domSelector=arrayObj[j][0]
		var $nodes=$("#"+OneMapID).find(domSelector)
		for (var i=0; i< $nodes.length; i++){
				var domId = $nodes[i]['id']||"";
				if (domId == "") {
					continue;
				}
				var componentType = "" //getComponentType(domId)
				var isJump = ""  //supportJump(componentType);
				var domName = "";
				var _$label = $("label[for="+domId+"]");
				if (_$label.length > 0){
				   domName = _$label[0].innerHTML;
				}
				domName = domName ;
				rtnObj[domId] = domName;
			}
	}
	var domJson = JSON.stringify(rtnObj);
	var responseText = $.m({
			ClassName: "web.DHCDocAPPBL",
			MethodName: "InsertBLItemMulit",
			BLTempRowID:OneMapRowID,domJson:domJson
		},false);
	}
function addclsRequired(){
	var CheckStr=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireItem",MapID);
	var itmmastid=$("#TesItemID").val();
	if (itmmastid!="") {
		var HideAry=MapStr.split("||");
		for (var i=0; i< HideAry.length; i++){
			var AcquireStr=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireArcItem",MapID,HideAry[i],itmmastid);
			if (AcquireStr!="") {
				if (CheckStr=="") CheckStr=AcquireStr;
				else CheckStr=CheckStr+"^"+AcquireStr;
			}
		}
	}
	if (CheckStr!=""){
		var CheckAry=CheckStr.split("^")
		for (var i=0;i<CheckAry.length;i++) {
			var OneCheckStr=CheckAry[i]
			var ID=OneCheckStr.split(String.fromCharCode(1))[0];
			var TiTle=OneCheckStr.split(String.fromCharCode(1))[1]
			if (($("#"+ID).hasClass('datagrid-f'))){
				$("div[for="+ID+"]").parent().find(".panel-title").addClass("clsRequired")
			}else if (($("#"+ID).prop('tagName')=="TABLE")){
				//普通的自定义table
				$("#"+ID).find("TD:contains('"+TiTle+"')").each(function(index, item){
					$(item).addClass("clsRequired");
				})
				//设置了panel的table
				$("#"+ID).parent().parent().find(".panel-title:contains("+TiTle+")").each(function(index, item){
					$(item).addClass("clsRequired");
				})
				
			}else if ($("#"+ID).length > 0){
				$("label[for="+ID+"]").addClass("clsRequired");
			}
		}
	}
	}
function ConTroClick(){
	$("#CancelBLApply").linkbutton('enable').addClass('btn-lightred');
	$("#SendBLApply").linkbutton('enable').addClass('btn-lightgreen');
	$("#SaveBLApply").linkbutton('enable').addClass('btn-lightgreen');
	$("#PrintBLApply,#PrintBLBar").linkbutton('enable');
	if (itemReqJsonStr==""){
		$("#CancelBLApply").linkbutton('disable').removeClass('btn-lightred');
		$("#SendBLApply").linkbutton('disable').removeClass('btn-lightgreen');
		$("#PrintBLApply,#PrintBLBar").linkbutton('disable');
	}else{
		if (PisStatus=="N"){
			$("#PrintBLApply,#PrintBLBar").linkbutton('disable');
		}else{
			if (PisStatus=="I") {
				if (PracticeFlag==1) {
					$("#SendBLApply").linkbutton('disable').removeClass('btn-lightgreen');
				}else{
					$("#SendBLApply").linkbutton('enable');
				}
				$("#CancelBLApply").linkbutton('enable').addClass('btn-lightred');
				$("#SaveBLApply").linkbutton('enable');
				$("#PrintBLApply,#PrintBLBar").linkbutton('disable');
			}else{
				$("#SendBLApply").linkbutton('disable').removeClass('btn-lightgreen');
				if (PisStatusSign!="AP"){
					$("#SaveBLApply").linkbutton('disable').removeClass('btn-lightgreen');
				}
				if ((PisStatusSign=="BC")||(PisStatusSign=="SC")||(PisStatusSign=="RP")||(PisStatus=="D")||(PisStatus=="DIAG")){
					$("#CancelBLApply").linkbutton('disable').removeClass('btn-lightred');
				}
				if (PisStatus=="D") {
					$("#PrintBLApply,#PrintBLBar").linkbutton('disable');
				}
				$('textbox').attr("disabled", true);
				$('.textbox').attr("disabled", true); 
				$('.checkbox').attr("disabled", true); 
				$HUI.combobox(".textbox combobox-f combo-f").disable();   
				$('.combo').attr("disabled", true);  
				$('input[type="checkbox"]').attr("disabled",true);
				$('textarea').attr("disabled", true);  /// 文本框
				$('input[type="text"]').attr("disabled", true);
			}
		}
	}

}
/// 页面兼容配置
function InitVersionMain(){
	
	/// 弹出界面时,检查申请采用新版录入界面
	if (DocMainFlag == 1){
		$('#tPanel').panel({closed:true});        /// 隐藏【申请信息】
		$('#fistPanel').panel({closed:true});        /// 隐藏【申请信息】
		$('#mainPanel').layout("remove","south"); /// 隐藏【按钮栏】 
		$('a:contains("取消申请")').hide();
		$('a:contains("发送")').hide();
		$('a:contains("打印")').hide();
		LoadCheckItemListDoc();      /// 加载病理检查项目
		var PanelWidth = window.parent.frames.GetPanelWidth();
		/*/// 面板【申请信息】大小调整 
		$('#mPanel').panel('resize',{width: PanelWidth ,height: 100});
		/// 面板【综合信息】大小调整
		$('#sPanel').panel('resize',{width: PanelWidth ,height: 210});
		/// 面板【病人病历】大小调整
		$('#cPanel').panel('resize',{width: PanelWidth ,height: 520});*/
	}else{
		LoadCheckItemList();         /// 加载病理检查项目
		//$("#itemList").on("click","[name='item']",TesItm_onClick);
		var tempckid="";
		$("#itemList").on("click","[name='item']",function(){
			tempckid=this.id;
			if($("#"+tempckid).is(':checked')){
				$("#itemList input[type='checkbox'][name="+this.name+"]").each(function(){
					if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
						$("#"+this.id).removeAttr("checked");
						if (ServerObj.BLItemMast=="Y"){
							ItemMastOff(this.id);
							ClickHidden(true,tempckid.replace("_","||"));
						}
					}
				})	
				var TesItemID = this.id;    /// 检查方法ID
				var TesItemDesc = $(this).parent().next().text(); /// 检查方法
				var itmmastid = TesItemID.replace("_","||");
				var arDefEmg= $(this).attr("data-defsensitive");	 /// 是否默认加急
				//ItemMastChang(itmmastid,TesItemDesc,arDefEmg)
				if ((typeof(isWriteFlag)!="undefined")&&(isWriteFlag!="Y")) {
					$.messager.alert("提示","仅有死亡患者才能填写尸检申请单！","info",function(){
						$("#"+tempckid).prop("checked",false)
					});
					return;
				}
				if ((typeof(isWriteFlag)=="undefined")&&(parent)&&(parent.IsPatDead=="Y")) {
					$.messager.alert("提示","患者已故!","info",function(){
						$("#"+tempckid).prop("checked",false)
					});
					return;
				}
				var LimitMsg = GetItmLimitMsg(itmmastid)
				if (LimitMsg != ""){
					$.messager.alert("提示","项目【" +TesItemDesc+ "】被限制使用：" + LimitMsg);
					$("#"+tempckid).prop("checked",false)
					return;	
				}
				if (ServerObj.BLItemMast=="Y"){
					if ((typeof(TakOrdMsg)!="undefined")&&(TakOrdMsg!="")) {
						$.messager.alert("提示",TakOrdMsg,"info",function(){
							$("#"+tempckid).prop("checked",false);
						});
						return;
					}
					new Promise(function(resolve,rejected){
						/// 验证药理病人是否允许开医嘱
						var ErrObject = GetPatNotTakOrdMsgArc(itmmastid);
						if (ErrObject.ErrMsg != ""){
							$.messager.alert("提示",ErrObject.ErrMsg,"warning",function(){
								if (ErrObject.ErrCode != 0){
									$("#"+tempckid).prop("checked",false);
								}else{
									resolve();
								}
							});
						}else{
							resolve();
						}
					}).then(function(){
						return new Promise(function(resolve,rejected){
							/// CDSS阻断预警
							if (typeof CDSSObj=='object'){
								CDSSObj.CheckOrder(EpisodeID,itmmastid.replace("_","||"),function(ret){
									if(ret) resolve();
								});
							}else{
								resolve()
							}
						});
					}).then(function(rtn){
						return new Promise(function(resolve,rejected){
							if (GetMRDiagnoseCount(itmmastid) == 0){
								var OrdNeedMMDiag=0;
								var ItemCatRowid=tkMakeServerCall("web.DHCDocOrderCommon", "GetOrderSubCat", itmmastid);
								if (OrdNeedMMDiagCat.indexOf("^"+ItemCatRowid+"^") >=0) {
									OrdNeedMMDiag=1;
								}
								if (OrdNeedMMDiag ==1) var NoDiagnosMsg="没有西医诊断,请先录入!";
								else  var NoDiagnosMsg="没有诊断,请先录入！"
								$.messager.alert("提示",NoDiagnosMsg,"info",function(){
									(function(callBackFun){
										new Promise(function(resolve,rejected){
											DiagPopWinNew(resolve);
										}).then(function(){
											if (GetMRDiagnoseCount(itmmastid)>0) {
												callBackFun();
											}else{
												$("#"+tempckid).prop("checked",false);
												return;
											}
										})
									})(resolve);
								})
							}else{
								resolve();
							}
						})
					}).then(function(rtn){
						return new Promise(function(resolve,rejected){
							//医嘱与特慢病是否匹配
							var NotChronicMatchMsg=ChkChronicOrdItm(itmmastid);
							if (NotChronicMatchMsg!="") {
								$.messager.alert("提示",NotChronicMatchMsg,"info",function(){
									$("#"+tempckid).prop("checked",false);
								});
								return;	
							}
							resolve();
						})
					}).then(function(){
						ItemMastOn(itmmastid,TesItemDesc,arDefEmg);
						ClickHidden(false,itmmastid);
					})
				}
			}else{
				if (ServerObj.BLItemMast=="Y"){
					ItemMastOff(tempckid);
					ClickHidden(true,tempckid.replace("_","||"));
				}
			}
		})
	}
}
/// 加载检查方法列表
function LoadCheckItemList(){
	/// 初始化检查方法区域
	$("#itemList").html('<tr style="height:2px;border:0px solid #ccc;"><td style="width:30px;border:0px solid #ccc;"></td><td style="border:0px solid #ccc;"></td><td style="width:30px;border:0px solid #ccc;"></td><td style="border:0px solid #ccc;"></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","JsonGetTraItmByCodeNew",{"Code":MapDesc,"LgHospID":LgHospID, "LocID":session['LOGON.CTLOCID']},function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// 检查方法列表
function InitCheckItemRegion(itemobj){	
	/// 标题行
	var htmlstr = '';
		//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;">'+ itemobj.text +'</td></tr>';

	/// 项目
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		if (j % 2 == 0){
			itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="item" type="checkbox"  class="checkbox" data-defsensitive="'+ itemArr[j-1].defSensitive +'"></input></td><td style="border-right:none;" >'+ itemArr[j-1].text +'</td>');
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}else{
			itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="item" type="checkbox"  class="checkbox" data-defsensitive="'+ itemArr[j-1].defSensitive +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
			}
	}
	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td style="border-right:none;"></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(htmlstr+itemhtmlstr)
}
function TesItm_onClick(e){
	if ($(this).is(':checked')){
		var TesItemID = e.target.id;    /// 检查方法ID
		var TesItemDesc = $(e.target).parent().next().text(); /// 检查方法
		var itmmastid = TesItemID.replace("_","||");
		var arDefEmg= $(e.target).attr("data-defsensitive");	 /// 是否默认加急
		//ItemMastChang(itmmastid,TesItemDesc,arDefEmg)
		if (ServerObj.BLItemMast=="Y"){
			if (TakOrdMsg!="") {
				$.messager.alert("提示",TakOrdMsg,"info",function(){
					$("#"+tempckid).prop("checked",false)
				});
				return;
			}
			ItemMastOn(itmmastid,TesItemDesc,arDefEmg)
		}
	}
	}
///点击隐藏
function ClickHidden(showflag,itmmastid){
		///点击隐藏
		var HideAry=MapStr.split("||")
		for (var i=0; i< HideAry.length; i++){
			var HiddenStr=tkMakeServerCall("web.DHCDocAPPBL","GetNeedHidenItem",MapID,HideAry[i],itmmastid)
			LastHiddernStr=HiddenStr
			if (HiddenStr!=""){
				var HiddenArry=HiddenStr.split("^")
				for (var j=0; j< HiddenArry.length; j++){
					if ($("#"+HiddenArry[j]).length > 0){
						var _$ID=$("#"+HiddenArry[j]);
						if ((_$ID.hasClass('combobox-f'))||(_$ID.hasClass('hisui-checkbox'))||(_$ID.hasClass('hisui-datetimebox'))||(_$ID.hasClass('hisui-datebox'))){
							if (showflag) {
								$("#"+HiddenArry[j]).next().show();
							}else{
								$("#"+HiddenArry[j]).next().hide();
							}							
						}else{
							if (showflag) {
								$("#"+HiddenArry[j]).show();
							}else{
								$("#"+HiddenArry[j]).hide();
							}
						}
						if (showflag) {
							$("label[for="+HiddenArry[j]+"]").show();
						}else{
							$("label[for="+HiddenArry[j]+"]").hide();
						}
					}
				}
			}
		}
	
	}
function CheckforUpdate(){
	var CheckStr=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireItem",MapID);
	var itmmastid=$("#TesItemID").val();
	if (itmmastid!="") {
		var HideAry=MapStr.split("||");
		for (var i=0; i< HideAry.length; i++){
			var AcquireStr=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireArcItem",MapID,HideAry[i],itmmastid);
			if (AcquireStr!="") {
				if (CheckStr=="") CheckStr=AcquireStr;
				else CheckStr=CheckStr+"^"+AcquireStr;
			}
		}
	}
	if (CheckStr!=""){
		var CheckAry=CheckStr.split("^")
		for (var i=0;i<CheckAry.length;i++) {
			var val="";
			var OneCheckStr=CheckAry[i]
			var ID=OneCheckStr.split(String.fromCharCode(1))[0];
			var Desc=OneCheckStr.split(String.fromCharCode(1))[1];
			var BLID=OneCheckStr.split(String.fromCharCode(1))[2];
			var ItemXType=OneCheckStr.split(String.fromCharCode(1))[3];
			var ItemXID=OneCheckStr.split(String.fromCharCode(1))[4];
			if ((ItemXType!="")&&(ItemXID!="")){
				val="默认有值";
				if (ItemXType=="checkbox"){
					var CheckObj = CheckCheckBox(ItemXID,ID,Desc);
					if (!CheckObj.CheckFlag){
						Desc=CheckObj.text;
						val="";
					}
				}
				if (ItemXType=="datagrid"){
					var CheckObj=CheckDataGrid(ItemXID,ID,Desc);
					if (!CheckObj.CheckFlag){
						Desc=CheckObj.text;
						val="";
					}
				}
			}else{
				if ($("#"+ID).length > 0){
					if ($("#"+ID).hasClass('combobox-f')){
						var val = $HUI.combobox("#"+ID).getValue(); 
					}else if ($("#"+ID).hasClass('hisui-checkbox')){
						var  val=$("#"+ID).prop("checked");
					}else if ($("#"+ID).hasClass('hisui-datetimebox')){
						var val = $HUI.datetimebox("#"+ID).getValue(); 		
					}else if ($("#"+ID).hasClass('hisui-datebox')){
						var val = $HUI.datebox("#"+ID).getValue();
							//$HUI.datebox("#"+ID).setValue(Val);  	
						
					}else if ($("#"+ID).hasClass('datagrid-f')){
						if (BLID!=""){
							var PageObj=eval(BLID);
							PageObj.OtherInfo();	//内部可能有一些界面处理
							var RtnObj=CheckRequiredData(ID);
							if (RtnObj.CheckFlag==false){
								$.messager.alert("提示",Desc+"相关的"+RtnObj.NullTitle+"不能为空!");
								return false;
							}
							continue
						}else{
							continue
						}
					}else if ($("#"+ID).prop("tagName")=="TABLE"){
						if (BLID!=""){
							var PageObj=eval(BLID);
							if (typeof PageObj.OtherInfo =="function"){
								var OtherInfo=PageObj.OtherInfo();
								for (x in OtherInfo){  
									if (OtherInfo[x]=="[]"){
										continue
									}
									val=val + OtherInfo[x];  
								} 
							}
						}
					}else{
						var val=$("#"+ID).val()
					}
				}
			}
			if (val==""){
				$.messager.alert("提示",Desc+"不能为空!");
				return false;
			}
		}
	}
	var CheckStrLenght=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireLength",MapID);
	if (CheckStrLenght!=""){
		var CheckAry=CheckStrLenght.split("^")
		for (var i=0;i<CheckAry.length;i++) {
			var OneCheckStr=CheckAry[i]
			var ID=OneCheckStr.split(String.fromCharCode(1))[0]
			var OneLength=OneCheckStr.split(String.fromCharCode(1))[2]
			if ($("#"+ID).length > 0){
				var val=$("#"+ID).val()
				var vallenght=val.length
				if (vallenght>OneLength){
					$.messager.alert("提示",OneCheckStr.split(String.fromCharCode(1))[1]+"长度过长,请重新填写!");
					return false;
					}
				}
			}
		}
	if (typeof CheckSaveInfo === "function") {
		var CheckSave=CheckSaveInfo()
		if (CheckSave==false){
			return false;
		}
	}
	return true;
}
function CheckRequiredData(TableName){
	var rowDatas = $('#'+TableName).datagrid('getRows');
	var Options= $('#'+TableName).datagrid('options');
	var columns=Options.columns[0];
	if (rowDatas.length==0){
		return {CheckFlag:false,NullTitle:""};
	}
	var CheckFlag=true;
	var NullTitle="";
	//只要有一行完整的必填项就行
	$.each(rowDatas, function(index, item){
		CheckFlag=true;
		var AllDataisEmpty=true;
		NullTitle="";
		$.each(columns, function(ColIndex, ColItem){
			if (typeof ColItem.Required =="undefined"){
				return true;
			}
			if (ColItem.Required===true){
				var val=item[ColItem.field];
				val=trim(val);
				if ((typeof val=="undefined")||(val=="")){
					CheckFlag=false;
					var title=ColItem.title;
					if (title==""){
						title=ColItem.field;
					}
					if (NullTitle==""){
						NullTitle=title
					}else{
						NullTitle=NullTitle+"、"+title
					}
				}else{
					AllDataisEmpty=false;
				}
			}
		})
		if ((CheckFlag==true)){
			return false;
		}
		if ((AllDataisEmpty==false)&&(NullTitle!="")){
			return false;
		}
	})
	return {CheckFlag:CheckFlag,NullTitle:NullTitle};
}
function Save(){
	var itmmastid = $("#TesItemID").val();  			   /// 医嘱项ID
	if ((itmmastid == "")&&(PisID=="")){
		$.messager.alert("提示:","请先选择病理检查项目！");
		return;
	}
	var ErrObject = GetPatNotTakOrdMsgArc(itmmastid);
	if (ErrObject.ErrMsg != ""){
		if (ErrObject.ErrCode != 0){
			$.messager.alert("提示",ErrObject.ErrMsg);
			return;
		}
	}
	//医嘱与特慢病是否匹配
	var NotChronicMatchMsg=ChkChronicOrdItm(itmmastid);
	if (NotChronicMatchMsg!="") {
		$.messager.alert("提示",NotChronicMatchMsg);
		return;	
	}
	var PatArrManMsg = GetPatArrManage();
	if (PatArrManMsg != ""){
		$.messager.alert("提示",PatArrManMsg);
		return;	
	}
	var rtn=CheckforUpdate()
	if (rtn==false){
		return false
	}
	var Savestr=tkMakeServerCall("web.DHCDocAPPBL","GetSaveItem",MapID)
	var SaveAry=Savestr.split("^")
	var JsonAry = new Array();
	for (var i=0;i<SaveAry.length;i++) {
		var ID=SaveAry[i];
		if ($("#"+ID).length > 0){
			if ($("#"+ID).hasClass('combobox-f')){
				var val = $HUI.combobox("#"+ID).getValue(); 
				var desc = $HUI.combobox("#"+ID).getText(); 
			}else if ($("#"+ID).hasClass('hisui-checkbox')){
				var  val=$("#"+ID).prop("checked");
				var  desc = $("label[for="+ID+"]").innerHTML;				
			}else if ($("#"+ID).hasClass('hisui-datetimebox')){
				var val = $HUI.datetimebox("#"+ID).getValue();
				var desc = 	$HUI.datetimebox("#"+ID).getValue();	
			}else if ($("#"+ID).hasClass('hisui-datebox')){
				var val = $HUI.datebox("#"+ID).getValue(); 
				var desc = $HUI.datebox("#"+ID).getValue(); 		
			}else if($("#"+ID).hasClass('combogrid-f')){
				var val = $HUI.combogrid("#"+ID).getValue(); 
				var desc = $HUI.combogrid("#"+ID).getText(); 
			}else{
				var val=$("#"+ID).val()
				var desc = $("#"+ID).val() 
			}
			var className = getComponentType(ID)
			JsonAry[JsonAry.length]={
				ID:ID,
				Val:val,
				Class:className,
				Desc:desc
			};
		}
	}
	//额外信息保存
	var otherinfo=""
	var rtnObj = {}
	if (BLIDStr!=""){
		var BLIDStrArry=BLIDStr.split("^")
		for (var i = 0; i < BLIDStrArry.length; i++) {
			var Obj=eval(BLIDStrArry[i]) 
			var BLObj=Obj.OtherInfo()
			if (BLObj!="") {$.extend(rtnObj, BLObj);}
		}
	}
	if (ServerObj.BLSaveOther=="Y"){
		var SaveObj=SaveOtherInfo()
		if (SaveObj!="") {$.extend(rtnObj, SaveObj);}
	}
	otherinfo=JSON.stringify(rtnObj);
	JsonAry[JsonAry.length]={
		ID:"OtherInfo",
		Val:otherinfo,
		Class:"Data"
	};
	//打印特殊信息维护
	var PrintInfo=""
	var rtnObj = {}
	if (BLIDStr!=""){
		var BLIDStrArry=BLIDStr.split("^")
		for (var i = 0; i < BLIDStrArry.length; i++) {
			var Obj=eval(BLIDStrArry[i]) 
			var BLObj=Obj.PrintInfo()
			if (BLObj!="") {$.extend(rtnObj, BLObj);}
		}
	}
	PrintInfo=JSON.stringify(rtnObj);
	JsonAry[JsonAry.length]={
		ID:"PrintInfo",
		Val:PrintInfo,
		Class:"Data"
	};
	var JsonStr=JSON.stringify(JsonAry);
	var recLocID = $HUI.combobox("#recLoc").getValue();    /// 接收科室ID
	if (recLocID==""){
		$.messager.alert("提示:","病理检查项目的接收科室不能为空！");
		return;
	}
	CPWCheck(itmmastid,function(SuccessFlag){
		if (SuccessFlag == false) {
		    	return ;
		    }
		var OEOrdStr=itmmastid+"^"+recLocID+"^"
		if (Oeori!="") {OEOrdStr=OEOrdStr+Oeori}
		var BillTypeID = "";
		if (typeof window.parent.frames.BillTypeID != "undefined"){
			BillTypeID = window.parent.frames.BillTypeID;  ///费别ID
		}
		var ChronicDiagCode=""
		if ((window.parent.frames)&&(window.parent.frames.GetChronicDiagCode)) {
			ChronicDiagCode=window.parent.frames.GetChronicDiagCode();
		}
		var rtn=$.cm({
		    ClassName : "web.DHCDocAPPBL",
		    MethodName : "InsertNewBLInformation",
		    dataType:"text",
		    "EpisodeID":EpisodeID,
		    "DocID":session['LOGON.USERID'],
		    "LocID":session['LOGON.CTLOCID'],
		    "Type":MapCode,
		    "OEOrdStr":OEOrdStr, "JsonStr":JsonStr, "PisID":PisID,"BillTypeID":BillTypeID,"ChronicDiagCode":ChronicDiagCode,
		    "EmConsultItm":EmConsultItm
	    },false);
	    if (rtn.split("^")[0]==0){
		    PisID = rtn.split("^")[1];
		    GetPisNoObj(PisID);
			websys_getTop().$.messager.alert("提示","保存成功！");
			/// 调用父框架函数
		    window.parent.frames.reLoadEmPatList();
		    if (ServerObj.PrintSet=="saveprint"){
			    Print()
			}
		}else{
			var ErrMsg=rtn.split("^")[1];
			if (ErrMsg=="") ErrMsg=rtn;
			websys_getTop().$.messager.alert("提示","病理申请单保存失败，失败原因:"+ErrMsg);  
	    }
    })
}
//临床路径检查，路径外医嘱填写变异
function CPWCheck(ArcimIDs,callBackFun) {
	new Promise(function(resolve,rejected){
		checkOrdItemToVar(EpisodeID,ArcimIDs,resolve);
	}).then(function(SuccessFlag){
		callBackFun(SuccessFlag);
	})
}
function InsertDoc(){
	var rtn=CheckforUpdate()
	if (rtn==false){
		return false
	}
	/*var itmmastid = $("#TesItemID").val();  			   /// 医嘱项ID
	if (itmmastid == ""){
		$.messager.alert("提示:","请先选择病理检查项目！");
		return;
	}*/
	var Savestr=tkMakeServerCall("web.DHCDocAPPBL","GetSaveItem",MapID)
	var SaveAry=Savestr.split("^")
	var JsonAry = new Array();
	for (var i=0;i<SaveAry.length;i++) {
		var ID=SaveAry[i];
		if ($("#"+ID).length > 0){
			if ($("#"+ID).hasClass('combobox-f')){
				var val = $HUI.combobox("#"+ID).getValue(); 
				var desc = $HUI.combobox("#"+ID).getText(); 
			}else if ($("#"+ID).hasClass('hisui-checkbox')){
				var  val=$("#"+ID).prop("checked");
				var  desc = $("label[for="+ID+"]").innerHTML;				
			}else if ($("#"+ID).hasClass('hisui-datetimebox')){
				var val = $HUI.datetimebox("#"+ID).getValue();
				var desc = 	$HUI.datetimebox("#"+ID).getValue();	
			}else if ($("#"+ID).hasClass('hisui-datebox')){
				var val = $HUI.datebox("#"+ID).getValue(); 
				var desc = $HUI.datebox("#"+ID).getValue(); 		
			}else{
				var val=$("#"+ID).val()
				var desc = $("#"+ID).val() 
			}
			var className = getComponentType(ID)
			JsonAry[JsonAry.length]={
				ID:ID,
				Val:val,
				Class:className,
				Desc:desc
			};
		}else{
		}
	}
	var otherinfo=""
	var rtnObj = {}
	if (BLIDStr!=""){
		var BLIDStrArry=BLIDStr.split("^")
		for (var i = 0; i < BLIDStrArry.length; i++) {
			var Obj=eval(BLIDStrArry[i]) 
			var BLObj=Obj.OtherInfo()
			if (BLObj!="") {$.extend(rtnObj, BLObj);}
		}
	}
	if (ServerObj.BLSaveOther=="Y"){
		var SaveObj=SaveOtherInfo()
		if (SaveObj!="") {$.extend(rtnObj, SaveObj);}
	}
	otherinfo=JSON.stringify(rtnObj);
	JsonAry[JsonAry.length]={
		ID:"OtherInfo",
		Val:otherinfo,
		Class:"Data"
	};
	if (rtnObj.PisReqSpec==""){
		var ConfirmPisSpec = dhcsys_confirm($g("该申请单未填写标本，是否发送?"));
	    if (ConfirmPisSpec == false) return;
	}
	//打印特殊信息维护
	var PrintInfo=""
	var rtnObj = {}
	if (BLIDStr!=""){
		var BLIDStrArry=BLIDStr.split("^")
		for (var i = 0; i < BLIDStrArry.length; i++) {
			var Obj=eval(BLIDStrArry[i]) 
			var BLObj=Obj.PrintInfo()
			if (BLObj!="") {$.extend(rtnObj, BLObj);}
		}
	}
	PrintInfo=JSON.stringify(rtnObj);
	JsonAry[JsonAry.length]={
		ID:"PrintInfo",
		Val:PrintInfo,
		Class:"Data"
	};
	var JsonStr=JSON.stringify(JsonAry);
	var recLocID = $HUI.combobox("#recLoc").getValue();    /// 接收科室ID
	var OEOrdStr=mListDataDoc.split("^")[5]+"^"+"^"
    var mItemParam=EpisodeID+ String.fromCharCode(1) +session['LOGON.USERID'];
    mItemParam=mItemParam+ String.fromCharCode(1) +session['LOGON.CTLOCID'];
    mItemParam=mItemParam+ String.fromCharCode(1) +MapCode;
    mItemParam=mItemParam+ String.fromCharCode(1) +OEOrdStr;
    mItemParam=mItemParam+ String.fromCharCode(1) +JsonStr;
    mItemParam=mItemParam+ String.fromCharCode(1) +mListDataDoc.split("^")[6];
    runClassMethod("web.DHCDocAPPBL","InsertNewBLInformationDoc",{"Pid":pid, "PisType":MapCode, "JsonStr":mItemParam},function(jsonString){
		if (jsonString < 0){
			window.parent.frames.InvErrMsg(MapDesc+"保存失败，失败原因:"+jsonString);
			return false;
		}
	},'',false)
	return true;
}
function getComponentType(id){
		var className = $("#"+id).attr("class")||"";
		
		if (className == "") {
			return "text";
		}else if ((className.indexOf("hisui-lookup")>=0)||(className.indexOf("lookup-text")>=0)) {
			return "lookup";
		} else if( className.indexOf("combobox-f") >=0 ) {
			return "combobox";
		} else if((className.indexOf("hisui-datebox")>=0)||(className.indexOf("datebox-f")>=0)) {
			return "datebox";
		} else if (className.indexOf("hisui-linkbutton")>=0) {
			return "button";
		} else if (className.indexOf("hisui-radio")>=0) {
			return "radio";
		} else if (className.indexOf("hisui-checkbox")>=0) {
			return "checkbox";
		} else {
			return "text";
		}
	}
function Send(){
	if (PisID==""){
		$.messager.alert("提示:","未保存的申请单不能发送！");
		return;
	}
	var CheckForPisSpec=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "CheckForPisSpec",
	    dataType:"text",
	    "PisID":PisID,
    },false);
	if (CheckForPisSpec=="0"){
		var ConfirmPisSpec = dhcsys_confirm($g("该申请单未填写标本，是否发送?"));
	    if (ConfirmPisSpec == false) return;
	}
	var BillTypeID = "";
	if (typeof window.parent.frames.BillTypeID != "undefined"){
		BillTypeID = window.parent.frames.BillTypeID;  ///费别ID
	}
	var InsurFlag=parent.$HUI.checkbox("#InsurFlag").getValue()?"Y":"N";
	/// 保存
	var UpdateObj={}
	new Promise(function(resolve,rejected){
			   	if (window.parent.frames.CASignObj){
			   	//电子签名
				window.parent.frames.CASignObj.CASignLogin(resolve,"OrderSave",false)
				}else{
					resolve(true);	
				}
	}).then(function(CAObj){
				return new Promise(function(resolve,rejected){
		    	if (CAObj == false) {
		    		return websys_cancel();
		    	} else{
		    	$.extend(UpdateObj, CAObj);
		    	resolve(true);
		    	}
			})
	}).then(function(){
		runClassMethod("web.DHCDocAPPBL","InsSendFlag",{"PisID":PisID,"UserID":session['LOGON.USERID'],"BillTypeID":BillTypeID,"InsurFlag":InsurFlag},function(jsonString){
			var ErrCode=jsonString.split("^")[0];
			if (ErrCode == -1){
				$.messager.alert("提示:","病理申请单已发送无需再次发送!");
			}else if (ErrCode < 0){
				var ErrMsg=jsonString.split("^")[1];
				if (ErrMsg=="") ErrMsg=rtn;
				$.messager.alert("提示:","病理申请单发送失败，失败原因:"+ErrMsg);
			}else{
				GetPisNoObj(PisID);
				$.messager.alert("提示:","发送成功！");
				/// 调用父框架函数
			    window.parent.frames.reLoadEmPatList();
				/// 电子病历框架函数
				window.parent.frames.InvEmrFrameFun();
				/// 数字签名调用
				window.parent.frames.TakeDigSign(PisID, "P",UpdateObj);
				/// CDSS同步
				if(typeof CDSSObj=='object'){
					CDSSObj.SynReqOrder(EpisodeID,PisID,"P");
				}
				if (ServerObj.PrintSet=="sentprint"){
			    Print()
			    }
			}
		},'',false)
	})
}

function Cancle(){
	runClassMethod("web.DHCAppPisMaster","revPisMain",{"PisID":PisID, "UserID":session['LOGON.USERID']},function(jsonString){
		if (jsonString == 0){
			GetPisNoObj(PisID);
			$.messager.alert("提示:","取消成功！");
			/// 调用父框架函数
		    window.parent.frames.reLoadEmPatList();
		}else if(jsonString == "-200"){   //sufan 2018-03-12
			$.messager.alert("提示:","已计费，不能取消申请！");
			}else if(jsonString == "-100"){   //sufan 2018-03-12
			$.messager.alert("提示:","医嘱不存在，不能取消申请！");
			}else if(jsonString == "-201"){   //sufan 2018-03-12
			$.messager.alert("提示:","已经停止的医嘱不用再停，不能取消申请！");
			}else if(jsonString == "-302"){   //sufan 2018-03-12
			$.messager.alert("提示:","已执行，不能取消申请！");
			}else if(jsonString == "-205"){   //sufan 2018-03-12
			$.messager.alert("提示:","更新失败，不能取消申请！");
			}else if(jsonString == "-206"){   //sufan 2018-03-12
			$.messager.alert("提示:","更新失败，不能取消申请！");
			}else{
			$.messager.alert("提示:","取消异常！"+jsonString);
		}
	},'',false)
}
// 打印
function Print(){
	if (PisID==""){
		$.messager.alert("提示:","未保存的申请单不能打印！");
		return;
	}
	var GetPrintTime=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "GetPrintTime",
	    dataType:"text",
	    PisID:PisID
    },false);
    if (GetPrintTime!=""){
	    var ConfirmPrintAll = dhcsys_confirm($g("申请单已经打印过,是否再次打印?"));
	    if (ConfirmPrintAll==false) return;
	}
	   
	var MyPara=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "GetPisPrintCon",
	    dataType:"text",
	    PrintUserID:session['LOGON.USERID'],
	    PisID:PisID
    },false);
    var MyList=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "GetPrintList",
	    dataType:"text",
	    PisID:PisID
    },false);
    /*if (MyListstr!=""){
	    MyListArr=MyListstr.split(String.fromCharCode(1))
	    for (var i = 0; i < MyListArr.length; i++) {
		     MyList.push(MyListArr[i]);
		    }
	    }*/
    DHCP_GetXMLConfig("InvPrintEncrypt",PrintTemp);
    DHC_PrintByLodop(getLodop(),MyPara,MyList,"","");
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_XMLPrint(myobj,MyPara,"");
	var PrintCall=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "GetPisPrintTemp",
	    dataType:"text",
	    PisType:MapCode, Adm :EpisodeID, CallFalg:1
    },false);
    if (PrintCall!=""){
	    DHCP_GetXMLConfig("InvPrintEncrypt",PrintCall);
		//var myobj=document.getElementById("ClsBillPrint");
		//DHCP_XMLPrint(myobj,"","");
		DHC_PrintByLodop(getLodop(),MyPara,"","","");
	}
	var RecordPrintTime=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "RecordPrintTime",
	    dataType:"text",
	    PisID:PisID,
	    UserID:session['LOGON.USERID'],
    },false);
}
/// 打印条码
function PrintBar(){
	PrintBarCode("",PisID)
}
function GetPisNoObj(Pisid){
	var JsonMyPara=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "GetReqJsonStr",
	    dataType:"text",
	    PisID:Pisid
    },false);
    PisID=Pisid
    JasonArr=eval(JsonMyPara)
    PisNo=JasonArr[0].PisNo
    oeori=JasonArr[0].oeori
    itemReqJsonStr=JasonArr[0].itemReqJsonStr
    itemReqJsonStr=eval(itemReqJsonStr)
    PisStatus=JasonArr[0].PisStatus
	PisStatusSign=JasonArr[0].PisStatusSign
    if (PisNo!=""){$("#PisNo").text(PisNo)}
    if (oeori!=""){$("#Oeori").text(oeori)}
	//加载已经保存的申请单数据
	LoaditemReqJsonStr()
	//加载其他信息
	if (ServerObj.BLLoadOther=="Y"){
		LoadOtherInfo(itemReqJsonStr)
	}
	//控制按钮
	ConTroClick()
}
function LoaditemReqJsonStr(){
	if (itemReqJsonStr!=""){
		for (var i = 0; i < itemReqJsonStr.length; i++) {
			var OneReqJson=itemReqJsonStr[i]
			var ID=OneReqJson.ID
			var Val=OneReqJson.Val
			var Desc=OneReqJson.Desc
			if ($("#"+ID).length > 0){
				if ($("#"+ID).hasClass('combobox-f')){
						$HUI.combobox("#"+ID).setValue(Val); 
						$HUI.combobox("#"+ID).setText(Desc); 
					}else if ($("#"+ID).hasClass('hisui-checkbox')){
						//$("#"+ID).attr("checked",Val); 
						$HUI.checkbox("#"+ID).setValue(Val); 
					}else if ($("#"+ID).hasClass('hisui-datetimebox')){
						$HUI.datetimebox("#"+ID).setValue(Val); 
					}else if ($("#"+ID).hasClass('hisui-datebox')){
						//var val = $HUI.datebox("#"+ID).getValue();
						$HUI.datebox("#"+ID).setValue(Val);  		
					}else{
						$("#"+ID).val(Val)
					}
				}
			}

		
		}
	}
/// 加载检查方法列表
function LoadCheckItemListDoc(){
	
	var arcItemList=mListDataDoc.split("!")[1];
	EmgFlag=arcItemList.split("^")[0];
	var recLoc=arcItemList.split("^")[1];
	$HUI.combobox("#recLoc").setValue(recLoc);
	/// 初始化检查方法区域
	$("#itemList").html('<tr style="height:2px;" ><td style="width:30px;"></td><td></td><td></td><td style="width:30px;"></td><td></td><td></td></tr>');
	runClassMethod("web.DHCAppPisMasterQuery","jsonExaItemListDoc",{"arcItemList":arcItemList},function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString
			InitCheckItemRegionDoc(jsonObjArr);
		}
	},'json',false)
}
/// 检查方法列表
function InitCheckItemRegionDoc(itemArr){
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var i=1; i<=itemArr.length; i++){
		$("#TesItemDesc").val(itemArr[i-1].text);
		$HUI.combobox("#recLoc").setText(itemArr[i-1].desc);
		itemhtmlArr.push('<td style="width:30px;">'+ i +'</td><td>'+ itemArr[i-1].text +'</td><td>'+ itemArr[i-1].desc +'</td>');
		if (i % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr style="height:30px;">' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
 	if ((i-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr style="height:30px;">' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td><td></td><td style="border-right:none;"></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(itemhtmlstr);

}
/// 获取病人的诊断记录数
function GetMRDiagnoseCount(itmmastid){

	var Count = 0;
	/// 调用医生站的判断
	runClassMethod("web.DHCAPPExaReport","GetMRDCount",{"EpisodeID":EpisodeID,"ARCIMRowId":itmmastid},function(jsonString){
		
		if (jsonString != ""){
			Count = jsonString;
		}
	},'',false)

	return Count;
}
function DiagPopWinNew(callback){
	var PatientID = $("#PatientID").text();  /// 病人ID
	var mradm = $("#mradm").text();			 /// 就诊诊断ID
	websys_showModal({
		url:"diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm,
		title:'诊断录入',
		width:screen.availWidth-100,height:screen.availHeight-200,
		onClose:function(){
			window.parent.frames.GetPatBaseInfo();  ///  加载病人信息
			if (callback) callback();
		}
	})
}
//验证医嘱与慢特病是否匹配
function ChkChronicOrdItm(itmmastid){
	if (typeof(window.parent.frames.GetChronicDiagCode) === 'function') {
		var ChronicDiagCode=window.parent.frames.GetChronicDiagCode();
		if (ChronicDiagCode!="") {
			var NotMatchMsg=$.cm({
				ClassName:"web.DHCAPPExaReport",
				MethodName:"ISChronicOrdItm",
				dataType:"text",
				AdmDr:EpisodeID,
				ChronicCode:ChronicDiagCode,
				sendArcimStr:itmmastid
			},false);
			return NotMatchMsg;
		}
	}
	return "";
}
/// 验证病人是否允许开医嘱
function GetPatNotTakOrdMsgArc(arExaItmID){
	var arcitemId = arExaItmID.replace("_","||");
	var ErrObject = "";
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsgArc",{"EpisodeID":EpisodeID,"arcitemId":arcitemId,"PPRowId":parent.PPRowId,"AdmReason":window.parent.frames.BillTypeID},function(jsonString){

		if (jsonString != ""){
			ErrObject = jsonString;
		}
	},'json',false)

	return ErrObject;
}
function resize(){
	var width=$(window).width();
	var height=$(window).height();
	$('#mainPanel').attr("style","width:"+width+"px;height:"+height+"px;");
	$('#mainPanel').layout("resize",{
		width:width+"px",
		height:height+"px"
	});
	$('#ItemListTitle').panel("resize",{width:$(window).width()-20});
	var BLIDStrArry=BLIDStr.split("^");
	for (var i = 0; i < BLIDStrArry.length; i++) {
		$("#"+BLIDStrArry[i]).panel("resize",{width:$(window).width()-20});
	}
	setTimeout(function() { 
    	if ($(".window-mask").is(":visible")){
			$(".messager-window").css({'top':($(window).height()-100)/2,'left':($(window).width()-300)/2});
		}
    });
}
/// 验证病人是否允许开医嘱 住院急诊留观押金控制
function GetPatArrManage(){

	var PatArrManMsg = "";
	var BillTypeID = "";
	if (typeof window.parent.frames.BillTypeID != "undefined"){
		BillTypeID = window.parent.frames.BillTypeID;  ///费别ID
	}
	var itmmastid = $("#TesItemID").val();  	
	var PirceStr=$.cm({
	    ClassName : "web.DHCDocOrderCommon",
	    MethodName : "GetOrderPriceConUom",
	    dataType:"text",
	    EpisodeID:EpisodeID, InsType :BillTypeID, OrderDepRowid:session['LOGON.CTLOCID'],
	    ArcimRowid:itmmastid
    },false);
	var amount =PirceStr.split("^")[0]; /// 金额
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCAPPExaReport","GetArrearsManage",{"EpisodeID":EpisodeID,"LgGroupID":LgGroupID,"LgLocID":LgCtLocID,"amount":amount},function(jsonString){

		if (jsonString != ""){
			PatArrManMsg = jsonString;
		}
	},'',false)

	return PatArrManMsg;
}
/// 医嘱的性别/年龄限制
function GetItmLimitMsg(itmmastid){
	
	var LimitMsg = 0;
	/// 医嘱的性别/年龄限制
	runClassMethod("web.DHCAPPExaReport","GetItmLimitMsg",{"EpisodeID":EpisodeID, "itmmastid":itmmastid},function(jsonString){

		LimitMsg = jsonString;
	},'',false)
	
	return LimitMsg;
}

//作为基本的申请单信息，供子面板调用
function ItemMastOn_Map(itmmastid,TesItemDesc,arDefEmg){
	$("#TesItemID").val(itmmastid);
	$("#TesItemDesc").val(TesItemDesc);
	var LocID = ""; var LocDesc = "";
	var OpenForAllHosp=0,LogLoc="";
	var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
	var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
	if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
	if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
	runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":itmmastid,"OrderDepRowId":LogLoc,"OpenForAllHosp":OpenForAllHosp},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			LocID = jsonObjArr[0].value;
			LocDesc = jsonObjArr[0].text;
		}
	},'json',false)

	$("#recLoc").combobox("setValue",LocID);
	$("#recLoc").combobox("setText",LocDesc);
}
function ItemMastOff_Map(itmmast){
	$("#TesItemID").val("");
	$("#TesItemDesc").val("");
	$("#recLoc").combobox("setValue","");
	$("#recLoc").combobox("setText","");
}
/// 是否允许填写申请单---供子面板调用
function GetIsWritePisFlag_Map(){
	$.cm({
	    ClassName : "web.DHCAppPisMasterQuery",
	    MethodName : "GetIsWritePisFlag",
	    dataType:"text",
	    "LgGroupID":session['LOGON.GROUPID'],
	    "LgUserID":session['LOGON.USERID'],
	    "LgLocID":session['LOGON.CTLOCID'],
	    "EpisodeID":EpisodeID,
	    "EmConsultItm":EmConsultItm
    },function(TakOrdMsg){
		if(TakOrdMsg != ""){
			$.messager.alert("提示:",TakOrdMsg);
		} 
	});
}

/// 获取checkbox是否有选择(""/1:无/有)
function CheckCheckBox(TabID,ItemID,Desc){
	var CheckFlag=false;
	var CheckArr = $("input[name="+ItemID+"]");
    for (var j=0; j < CheckArr.length; j++){
	    if($('#'+CheckArr[j].id).is(':checked')){
		    CheckFlag=true;
		    break;
	    }
    }
    return {CheckFlag:CheckFlag,text:Desc};
}

/// 获取datagrid是否符合必填元素判断,返回对象
function CheckDataGrid(TabID,IDStr,DescStr){
	var SubIDArr=IDStr.split("*");
	var DescArr=DescStr.split("*");
	var Options= $('#'+TabID).datagrid('options');
	var Columns=Options.columns[0];
	var Rows = $('#'+TabID).datagrid('getRows');
	if (Rows.length==0){
		//没有表格列，直接退出
		return {CheckFlag:false,text:DescArr[0]};
	}
	
	//所有行都为空标识
	var AllNull=true;	
	for (var i=0; i < Rows.length; i++){
		$('#'+TabID).datagrid('endEdit', i); 
		var ExitData=false;
		$.each(Columns, function(ColIndex, ColItem){
			if (typeof ColItem.editor =="undefined"){
				return true;
			}
			var field=ColItem.field;
			var Val=Rows[i][field];
			if (Val!=""){
				//如果行上编辑元素有输入，则该行必须有必填元素
				ExitData=true;
			}
		})
		if (!ExitData) continue;		
		for (var j=0; j < SubIDArr.length; j++){
			var SubID=SubIDArr[j];
			var Val=Rows[i][SubID];
			if (Val==""){
				return {CheckFlag:false,text:DescArr[j]};
			}
			AllNull=false;
		}
	}
	if (AllNull) return {CheckFlag:false,text:DescArr[0]}
	return {CheckFlag:true,text:""};
}

window.onbeforeunload = function(event) { 
	if (PisID != ""){
		var RtnFlag="1"
		runClassMethod("web.DHCAppPisMaster","InsCheckSend",{"Pid":PisID},function(jsonString){
			RtnFlag=jsonString;
		},'json',false)
		if (RtnFlag == "0"){
				return "还未发送申请单，是否离开此界面"
			}else{
				return;	
		}
	}else{ return;}
}
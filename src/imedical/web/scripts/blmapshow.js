var DocMainFlag = "";   /// 医生站界面弹出标示
window.onload = function(){ 
	var valbox = $HUI.panel("#ItemListTitle",{
			title:MapDesc,
		});
} 
/// 页面兼容配置
function InitVersionMain(){
	
	/// 弹出界面时,检查申请采用新版录入界面
	if (DocMainFlag == 1){
		$('#tPanel').panel({closed:true});        /// 隐藏【申请信息】
		$('#mainPanel').layout("remove","south"); /// 隐藏【按钮栏】
		$('a:contains("取消申请")').hide();
		$('a:contains("发送")').hide();
		$('a:contains("打印")').hide();
		LoadCheckItemListDoc();      /// 加载病理检查项目
		LoadPisNoFlag();             /// 设置活体组织申请单加急或冰冻标志
		var PanelWidth = window.parent.frames.GetPanelWidth();
		/// 面板【申请信息】大小调整 
		$('#mPanel').panel('resize',{width: PanelWidth ,height: 100});
		/// 面板【综合信息】大小调整
		$('#sPanel').panel('resize',{width: PanelWidth ,height: 210});
		/// 面板【病人病历】大小调整
		$('#cPanel').panel('resize',{width: PanelWidth ,height: 520});
	}else{
		LoadCheckItemList();         /// 加载病理检查项目
		$("#itemList").on("click","[name='item']",TesItm_onClick);
		var tempckid="";
		$("#itemList").on("click","[name='item']",function(){
			tempckid=this.id;
			if($("#"+tempckid).is(':checked')){
				$("#itemArcList input[type='checkbox'][name="+this.name+"]").each(function(){
					if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
						$("#"+this.id).removeAttr("checked");
						}
					})	
				}else{
					}
			})
	}
}
/// 加载检查方法列表
function LoadCheckItemList(){
	/// 初始化检查方法区域
	$("#itemList").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","JsonGetTraItmByCodeNew",{"Code":MapCode},function(jsonString){
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
		itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="item" type="checkbox" data-defsensitive="'+ itemArr[j-1].defSensitive +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
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
		ItemMastChang(itmmastid,TesItemDesc,arDefEmg)
	}
	
	}
function CheckforUpdate(){
	var CheckStr=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireItem")
	if (CheckStr!=""){
		var CheckAry=CheckStr.split("^")
		for (var i=0;i<CheckAry.length;i++) {
			var OneCheckStr=CheckAry[i]
			var ID=OneCheckStr.split(String.fromCharCode(1))[0]
			if ($("#"+ID).length > 0){
				if ($("#"+ID).hasClass('.hisui-combobox')){
					var val = $HUI.combobox("#"+ID).getValue(); 
				}else if ($("#"+ID).hasClass('.hisui-checkbox')){
					var  val=$("#"+ID).prop("checked");
				}else{
					var val=$("#"+ID).val()
					}
				if (val==""){
					$.messager.alert("提示",OneCheckStr.split(String.fromCharCode(1))[1]+"不能为空!");
					return false;
					}
				
				}
			
			}
		}
	}
function Save(){
	var rtn=CheckforUpdate()
	if (rtn==false){
		return false
		}
	var itmmastid = $("#TesItemID").val();  			   /// 医嘱项ID
	if (itmmastid == ""){
		$.messager.alert("提示:","请先选择病理检查项目！");
		return;
	}
	var Savestr=tkMakeServerCall("web.DHCDocAPPBL","GetSaveItem")
	var SaveAry=Savestr.split("^")
	var JsonAry = new Array();
	for (var i=0;i<SaveAry.length;i++) {
		var ID=SaveAry[i]
		if ($("#"+ID).length > 0){
			if ($("#"+ID).hasClass('.hisui-combobox')){
				var val = $HUI.combobox("#"+ID).getValue(); 
			}else if ($("#"+ID).hasClass('.hisui-checkbox')){
				var  val=$("#"+ID).prop("checked");
			}else{
				var val=$("#"+ID).val()
				}
			JsonAry[JsonAry.length]={
				ID:ID,
				Val:val
			};
			}
		}
	var JsonStr=JSON.stringify(JsonAry);
	var recLocID = $HUI.combobox("#recLoc").getValue();    /// 接收科室ID
	var OEOrdStr=itmmastid+"^"+recLocID+"^"
	var rtn=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "InsertNewBLInformation",
	    dataType:"text",
	    "EpisodeID":EpisodeID,
	    "DocID":session['LOGON.USERID'],
	    "LocID":session['LOGON.CTLOCID'],
	    "Type":MapCode,
	    "OEOrdStr":OEOrdStr, "JsonStr":JsonStr, "PisID":PisID
    },false);
    if (rtn.split("^")[0]==0){
		PisID = rtn.split("^")[1];
	    GetPisNoObj(rtn.split("^")[1]);
		$.messager.alert("提示:","保存成功！");
		/// 调用父框架函数
	    window.parent.frames.reLoadEmPatList();
	    }else{
		  $.messager.alert("提示:","病理申请单保存失败，失败原因:"+rtn.split("^")[1]);  
		    }
	/*/// 保存
	runClassMethod("web.DHCAppPisMaster","Insert",{"PisType":"CYT", "PisID":PisID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","病理申请单保存失败，失败原因:"+jsonString);
		}else{
			PisID = jsonString;
			GetPisNoObj(PisID);
			$.messager.alert("提示:","保存成功！");
			/// 调用父框架函数
		    window.parent.frames.reLoadEmPatList();
		}
	},'',false)
	*/
	}
function Send(){
	if (PisID==""){
		$.messager.alert("提示:","未保存的申请单不能发送！");
		return;
		}
	var BillTypeID = "";
	if (typeof window.parent.frames.BillTypeID != "undefined"){
		BillTypeID = window.parent.frames.BillTypeID;  ///费别ID
	}
	/// 保存
	runClassMethod("web.DHCDocAPPBL","InsSendFlag",{"PisID":PisID,"UserID":session['LOGON.USERID'],"BillTypeID":BillTypeID},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","病理申请单已发送无需再次发送!");
		}else if (jsonString < 0){
			$.messager.alert("提示:","病理申请单发送失败，失败原因:"+jsonString);
		}else{
			GetPisNoObj(PisID);
			$.messager.alert("提示:","发送成功！");
			/// 调用父框架函数
		    window.parent.frames.reLoadEmPatList();
			/// 电子病历框架函数
			window.parent.frames.InvEmrFrameFun();
		}
	},'',false)
	}

/// 打印条码
function PrintPisBar(flag){
	window.parent.frames.PrintBar(PisID,1)
}
function Cancle(){
	runClassMethod("web.DHCAppPisMaster","revPisMain",{"PisID":PisID, "UserID":session['LOGON.USERID']},function(jsonString){
		if (jsonString == 0){
				GetPisNoObj(PisID);
				$.messager.alert("提示:","取消成功！");
				/// 调用父框架函数
			    window.parent.frames.reLoadEmPatList();
			}else if(jsonString == "-12"){   //sufan 2018-03-12
				$.messager.alert("提示:","已执行，不能取消申请！");
				}else{
				$.messager.alert("提示:","取消异常！");
			}
		},'',false)
	}
// 打印
function Print(){
	if (PisID==""){
		$.messager.alert("提示:","未保存的申请单不能打印！");
		return;
		}
	var MyPara=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "GetPisPrintCon",
	    dataType:"text",
	    PisID:PisID
    },false);
    DHCP_GetXMLConfig("InvPrintEncrypt",MapCode);
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}
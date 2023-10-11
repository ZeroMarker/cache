//===========================================================================================
// 作者：      nk
// 编写日期:   2021-05-21
// 描述:	   量表展示页面JS
//===========================================================================================
var IsPopFlag = "";     /// 操作模式
var del = String.fromCharCode(2);

/// JQuery 初始化页面
$(function(){
	Init(); 
	InitEvent();
	PageHandle();
	Translate();
})
window.onload = function(){
	if(typeof HISUIStyleCode!="undefined" && HISUIStyleCode=="lite"){
		$(".list-panel").addClass('list-panel-lite').removeClass('list-panel');
		$(".list-title").addClass('list-title-lite').removeClass('list-title');
	}
}

/// 页面初始化函数
function Init(){
	LoadPageScore();     /// 加载页面评分内容
}

function InitEvent(){
	$(".tabform").on("click","input[name^='grp']",TakCalScore)
	
	$("#BtnSave").click(SaveTakScore);
	$("#BtnCancel").click(CancelTakScore);
	$("#BtnCureAdvise").click(CureAdvise)
}

function PageHandle(){
	//0-预览 1-新建 2-修改
	if (ServerObj.EditFlag == 0){
		$("#BtnSave").hide();    /// 确认
		$("#BtnCancel").hide();  /// 取消
		$("#BtnCureAdvise").hide();  /// 治疗医嘱建议
		$("input[name^='grp']").attr("disabled",'disabled');
	}
	else if (ServerObj.EditFlag == 1){
		$("#BtnSave").show();    /// 确认
		$("#BtnCancel").hide();  /// 取消
		$("#BtnCureAdvise").show();  /// 治疗医嘱建议
	}
	else if (ServerObj.EditFlag == 2){
		$("#BtnSave").show();    /// 确认
		$("#BtnCancel").show();  /// 取消
		$("#BtnCureAdvise").show();  /// 治疗医嘱建议
	}
	else if (ServerObj.EditFlag == -1){
		$("#BtnSave").hide();    /// 确认
		$("#BtnCancel").hide();  /// 取消
		$("#BtnCureAdvise").hide();  /// 治疗医嘱建议
	}	
}

function CureAdvise(){
	if(ServerObj.EpisodeID==""){
		$.messager.alert("提示","未获取到有效就诊","warning");
		return;
	}
	if(ServerObj.DCASStatus=="A"){
		$.messager.alert("提示","请先保存评分数据","warning");
		return;
	}
    var href = "doccure.applytree.hui.csp?EpisodeID=" + ServerObj.EpisodeID+"&ParaType=CureAdvise"+"&EmConsultItm=&CureAssScoreID="+ServerObj.AssScaleApplyID;
 	websys_showModal({
		url:href,
		title:'治疗申请建议',
		width:'95%',height:'95%',
		onClose:function(){
			//释放患者锁
			$.cm({
				ClassName:"web.DHCDocOrderCommon",
				MethodName:"OrderEntryClearLock"
			},false)	
		}
	});
}

/// 计算评分
function TakCalScore(){
	
	var id = this.id;
	/// table表中checkbox勾选
	if ($(this).closest("table").length != 0){
		var index = $(this).closest("tr").index();
		var checkboxs = $(this).closest("tr").find("input[name^='grp']");
		for(var i=0; i<checkboxs.length; i++){
			if (checkboxs[i].id != id){
				$(checkboxs[i]).prop('checked', false);
			}
		}
	}else{
		var otype=$("#"+id).attr("type");
		if(otype!="checkbox"){
			//var checkboxs = $("input[name='"+ this.name+"']");
			var checkboxs = $("input[type='radio']");
			for(var i=0; i<checkboxs.length; i++){
				if (checkboxs[i].id != id){
					$(checkboxs[i]).prop('checked', false);
				}
			}
		}
	}

	var Score = 0;
	$("input[name^='grp']:checked").each(function(){
		if (this.value != ""){
			Score = Score + parseInt(this.value);
		}
	})
	$("#count").text(Score);
}

/// 关闭弹出窗口
function TakClsWin(){

	window.parent.commonCloseWin();  /// 返回参数
}

/// 评分表保存
function SaveTakScore(){
	var mListData = getListData();
	var scoreVal = $("#count").text();
	if(typeof mListData!="string") return;
	var UpdateObj={};
	new Promise(function(resolve,rejected){
        //电子签名
        CASignObj.CASignLogin(resolve,"CureScale",false)
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
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.AssScale",
			MethodName:"Insert",
			ID:ServerObj.AssScaleApplyID,
			mListData:mListData,
			dataType:"text"
		},function(ret){
			var val="",msg="";
			if(ret.indexOf("^")>-1){
				var msg=ret.split("^")[1];	
				var val=ret.split("^")[0];	
			}else{
				val=ret;
			}
			if (val < 0){
				$.messager.alert("提示:","评分保存失败,错误代码:"+val+",错误描述:"+msg,"warning");
			}else{
				ServerObj.AssScaleApplyID = ret;
				if ( UpdateObj.caIsPass==1){
					CASignObj.SaveCASign(UpdateObj.CAObj, ret, "CureScale");
					$.cm({
						ClassName:"DHCDoc.DHCDocCure.AssScale",
						MethodName:"GetCAImage",
						RowId:ret,
						dataType:"text"
					},function(CAImage){
						ServerObj.CAImage=CAImage;
						LoadCAImage();
					})
				}
				if (IsPopFlag == 1) TakClsWin();  /// 关闭弹出窗口
				window.parent.InvScoreCallBack(ServerObj.AssScaleApplyID, "2"); /// 评分回调函数
			}	
		});
    })
}

/// 加载页面评分内容
function LoadPageScore(){
	
	if (ServerObj.AssScaleApplyID == "") return;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScale",
		MethodName:"JsGetFormScore",
		ID:ServerObj.AssScaleApplyID,
		dataType:"text"
	},function(jsonString){
		if (jsonString != null){
			var jsonObj=JSON.parse(jsonString); 
			$("#count").text(jsonObj.Score);    /// 分值
			var itemArr = jsonObj.items;
			for(var i=0; i<itemArr.length; i++){
				if ((itemArr[i].type == "radio")||(itemArr[i].type == "checkbox")){
				    $("input[id='"+ itemArr[i].key +"']").attr("checked",'checked');
				}else if(itemArr[i].type == "datebox"){
					$("input[id='"+ itemArr[i].key +"']").datebox("setValue",itemArr[i].val);	
				}else{
					$("input[id='"+ itemArr[i].key +"']").val(itemArr[i].val);	
				}
			}
		}else{
			
		}
		LoadCAImage();	
	});
}
function LoadCAImage(){
	if (ServerObj.CAImage!=""){
        $("#CAImage").attr("src",ServerObj.CAImage);
    }else{
		$("#CAImage").attr("src","");    
	}
}

function getListData(){
	
	/// 评分主信息
	var scoreVal = $("#count").text();    /// 分值
	var mListData = ServerObj.EpisodeID +"^"+ ServerObj.LgUserID +"^"+ ServerObj.BusType +"^"+ ServerObj.AssScaleID +"^"+ scoreVal;
	
	/// 评分表单详情
	var itemArr = [];
	var items = $("input[name^='grp']:checked");
	for (var i=0; i<items.length; i++){
		itemArr.push(items[i].id +"^"+ items[i].value +"^"+ items[i].type);
	}
	
	if (itemArr.length == 0){
		$.messager.alert("提示:","未选择任何评分项，不能保存！","warning");
		return;
	}
	var items = $("input[id^='validatebox']");
	for (var i=0; i<items.length; i++){
		itemArr.push(items[i].id +"^"+ items[i].value +"^"+ items[i].type);
	}
	var items = $("input[id^='datebox']");
	for (var i=0; i<items.length; i++){
		itemArr.push(items[i].id +"^"+ $(items[i]).datebox("getValue") +"^"+ "datebox");
	}
	
	var mListData = mListData + del + itemArr.join("@");	
	return mListData;
}

function CancelTakScore(){
	var mListData = ServerObj.EpisodeID +"^"+ ServerObj.LgUserID +"^"+ ServerObj.BusType +"^"+ ServerObj.AssScaleID;
	if(typeof mListData!="string") return;
	var UpdateObj={};
	new Promise(function(resolve,rejected){
        //电子签名
        CASignObj.CASignLogin(resolve,"CancelCureScale",false)
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
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.AssScale",
			MethodName:"Cancel",
			ID:ServerObj.AssScaleApplyID,
			mListData:mListData,
			dataType:"text"
		},function(ret){
			var val="",msg="";
			if(ret.indexOf("^")>-1){
				var msg=ret.split("^")[1];	
				var val=ret.split("^")[0];	
			}else{
				val=ret;
			}
			if (val < 0){
				$.messager.alert("提示:","撤销失败,错误代码:"+val+",错误描述:"+msg,"warning");
			}else{
				ServerObj.AssScaleApplyID = ret;
				if ( UpdateObj.caIsPass==1){
					CASignObj.SaveCASign(UpdateObj.CAObj, ret, "CancelCureScale");
					
					ServerObj.CAImage="";
					LoadCAImage();
				}
				if (IsPopFlag == 1) TakClsWin();  /// 关闭弹出窗口
				window.parent.InvScoreCallBack(ServerObj.AssScaleApplyID, "1"); /// 评分回调函数
			}	
		});	
	})
}

function Translate(){
	var rtnObj = {}
	var arrayObj = new Array(
      ".tabform div[class='title']",
	  ".tabform span[class='item']",
	  ".tabform label[class='grp-title']",
	  ".tabform p"
	);
	for( var i=0;i<arrayObj.length;i++) {
		var domSelector=arrayObj[i];
		for(j=0;j<$(domSelector).length;j++){
			var domText=$.trim($($(domSelector)[j]).text());
			if(domText.length>0){
				//console.log(domText+",,"+$g(domText))
				$(domSelector)[j].innerHTML=$g(domText); //基础平台
				//$(domSelector)[j].innerText=$g(domText); //基础平台
			}
		}
	}
}
var LastHiddernStr="";
var LastSelCureEffect="";
window.onload = function(){ 
    //控制按钮
    ConTroClick();
    
    //加载已经保存的申请单数据
	LoaditemReqJsonStr();
	
	//翻译
    TransLate();
} 
$(function(){
	if(ServerObj.MapID==""){
		$.messager.alert("提示","该治疗申请项目未维护对应的治疗评估模板项目,请联系管理员!");
		return false;	
	}
		
	//初始化医嘱表格
	InitVersionMain();
	//缓存加载数据
	CallStorageAllCache();
	//表单初始化
	if (ServerObj.BLIDStr!=""){
		var BLIDStrArry=ServerObj.BLIDStr.split("^")
		for (var i = 0; i < BLIDStrArry.length; i++) {
			var oneBLIDStr=BLIDStrArry[i];
			var oneBLIDArr=oneBLIDStr.split(String.fromCharCode(1));
			if(oneBLIDArr[1]==1){
				var Obj=eval("("+oneBLIDArr[0]+")") 
				if(typeof(Obj.Init)=="function"){
					Obj.Init()
				}
			}
		}
	}
	if (ServerObj.BLInit=="Y"){
		if(typeof(Init)=="function"){
			Init()
		}
	}
	
	//加载其他信息
	if (ServerObj.BLLoadOther=="Y"){
		if(typeof(LoadOtherInfo)=="function"){
			LoadOtherInfo(itemReqJsonStr)
		}
	}
    //加载必填项
    addclsRequired();
    InitEvent();
})

function InitEvent(){
    $("#CureAssSave").click(function(){
        Save("Y");
    })  
    $("#CureAssPrt").click(function(){
        CureAssPrt();
    })
}

/// 页面兼容配置
function InitVersionMain(){

}

function CallStorageAllCache(){
	if (ServerObj.CacheMapRowIDStr!=""){
		storageAllCache.storage(ServerObj.CacheMapRowIDStr,ServerObj.CacheMapIDStr)
	}
}

function addclsRequired(){
	var CheckStr=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireItem",ServerObj.MapID);
	var itmmastid=$("#TesItemID").val();
	if (itmmastid!="") {
		var HideAry=ServerObj.MapStr.split("||");
		for (var i=0; i< HideAry.length; i++){
			var AcquireStr=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireArcItem",ServerObj.MapID,HideAry[i],itmmastid);
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
			var ID=OneCheckStr.split(String.fromCharCode(1))[0]
			if ($("#"+ID).length > 0){
				$("label[for="+ID+"]").addClass("clsRequired");
			}
		}
	}
}

function CheckBeforeSaveAsTemp(SaveAsTemp,TempType){
	var MapCode=ServerObj.MapCode;
	itemReqJsonStr=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Assessment",
		MethodName:"GetAssTemplate",
		MapID:ServerObj.MapID,
		Type:TempType,
		UserID:LgUserID,
		dataType:"text"
	},false)
	if((itemReqJsonStr!="")&&(SaveAsTemp)){
		var conflag=dhcsys_confirm("已存在相应模板,是否继续保存?");
		return conflag;
	}
	if((itemReqJsonStr=="")&&(!SaveAsTemp)){
		$.messager.alert("提示","未有对应模板,请先保存!","warning");
		return false;
	}
	LastSelCureEffect=TempType
	return true;
}
function CureAssTemp_Click(TempType){
	var MapCode=ServerObj.MapCode;
	var satboj=$HUI.checkbox("#SaveAsTemp");
	var SaveAsTemp=satboj.getValue();
	var ret=CheckBeforeSaveAsTemp(SaveAsTemp,TempType);
	if(!ret)return;
	if(SaveAsTemp){
		var rtn=CheckforUpdate()
		if (rtn==false){
			return false
		}

		var JsonStr=GetSaveJsonStr(SaveAsTemp);
		var rtn=$.cm({
		    ClassName : "DHCDoc.DHCDocCure.Assessment",
		    MethodName : "SaveAssTemplate",
		    dataType:"text",
		    MapID:ServerObj.MapID,
		    Type:TempType,
		    UserID:LgUserID,
		    "JsonStr":JsonStr
	    },false);
		
	    if (rtn.split("^")[0]==0){
		    myID = rtn.split("^")[1];
		    //GetPisNoObj(myID);
			$.messager.alert("提示:","保存成功！");
			satboj.setValue(false);
		}else{
			$.messager.alert("提示:","保存失败，失败原因:"+rtn);  
	    }
	}else{
		ShowTemp(TempType)	
	}	
}

function ShowTemp(TempType){
	/*var MapCode=ServerObj.MapCode;
	itemReqJsonStr=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Assessment",
		MethodName:"GetAssTemplate",
		MapID:ServerObj.MapID,
		Type:TempType,
		dataType:"text"
	},false)*/
	itemReqJsonStr=eval(itemReqJsonStr);
	LoaditemReqJsonStr();
}

function GetSaveJsonStr(SaveAsTemp){
	if(SaveAsTemp){
		var Savestr=tkMakeServerCall("DHCDoc.DHCDocCure.Assessment","GetCacheItem",ServerObj.MapID);
	}else{
		var Savestr=tkMakeServerCall("web.DHCDocAPPBL","GetSaveItem",ServerObj.MapID);
	}
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
			}else if ($("#"+ID).hasClass('hisui-timespinner')){
				var val = $HUI.timespinner("#"+ID).getValue(); 		
			}else if ($("#"+ID).hasClass('hisui-numberbox')){
				var val = $HUI.numberbox("#"+ID).getValue(); 		
			}else if($("#"+ID).hasClass('hisui-radio')){
				//{"ID":"CBAssContraindications_No","Val":"CBAssContraindications_Yes","Class":"radio","Desc":"CBAssContraindications"}
				var RadioNameArr=ID.split("_");
				var RadioID=$("#"+ID).attr("name");
				if(RadioID==""){
					for(var loop=0;loop<RadioNameArr.length-1;loop++){
						if(RadioID==""){
							RadioID=RadioNameArr[loop]	
						}else{
							RadioID=RadioID+"_"+RadioNameArr[loop];
						}
					}
				}
				if(RadioID==""){RadioID=ID}
				var checkedRadioJObj = $("input[name='"+RadioID+"']:checked");
            	//$.messager.alert("提示","value="+checkedRadioJObj.val()+" , label="+checkedRadioJObj.attr("label"));
            	var val=checkedRadioJObj.val(); //radio_check
            	var desc=RadioID;
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
	if (ServerObj.BLIDStr!=""){
		var BLIDStrArry=ServerObj.BLIDStr.split("^")
		for (var i = 0; i < BLIDStrArry.length; i++) {
			var oneBLIDStr=BLIDStrArry[i];
			var oneBLIDArr=oneBLIDStr.split(String.fromCharCode(1));
			if(oneBLIDArr[1]==1){
				var Obj=eval("("+oneBLIDArr[0]+")") 
				if(typeof(Obj.OtherInfo)=="function"){
					var BLObj=Obj.OtherInfo()
					if (BLObj!="") {$.extend(rtnObj, BLObj);}
				}
			}
		}
	}
	if (ServerObj.BLSaveOther=="Y"){
		if(typeof(SaveOtherInfo)=="function"){
			var SaveObj=SaveOtherInfo()
			if (SaveObj!="") {$.extend(rtnObj, SaveObj);}
		}
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
	if (ServerObj.BLIDStr!=""){
		var BLIDStrArry=ServerObj.BLIDStr.split("^")
		for (var i = 0; i < BLIDStrArry.length; i++) {
			var oneBLIDStr=BLIDStrArry[i];
			var oneBLIDArr=oneBLIDStr.split(String.fromCharCode(1));
			if(oneBLIDArr[1]==1){
				var Obj=eval(oneBLIDArr[0]) 
				if(typeof(Obj.PrintInfo)=="function"){
					var BLObj=Obj.PrintInfo()
					if (BLObj!="") {$.extend(rtnObj, BLObj);}
				}
			}
		}
	}
	PrintInfo=JSON.stringify(rtnObj);
	JsonAry[JsonAry.length]={
		ID:"PrintInfo",
		Val:PrintInfo,
		Class:"Data"
	};
	var JsonStr=JSON.stringify(JsonAry);	
	return JsonStr;
}

function Save(SaveStatus){
    var UpdateObj={}
    if(typeof CASignObj == 'undefined'){
        CASignObj=window.parent.CASignObj;
    }
    new Promise(function(resolve,rejected){
        if (!CheckforUpdate()){
            return false;
        }else{
            resolve();
        }
    }).then(function (){
        return new Promise(function(resolve,rejected){
            //电子签名
            CASignObj.CASignLogin(resolve,"CureAss",false)
        }).then(function(CAObj){
            return new Promise(function(resolve,rejected){
                if (CAObj == false) {
                    return websys_cancel();
                } else{
                    $.extend(UpdateObj, CAObj);
                    resolve(true);
                }
            })
        })  
    }).then(function(){
        var JsonStr=GetSaveJsonStr();
        
        var DCARowId=ServerObj.DCARowId;
        var OrdExecDR="";
        var UpdateStatus="Y";
        //alert(JsonStr)
	    var Para=DCARowId+"^"+ServerObj.DCAssRowId+"^"+JsonStr+"^"+LgUserID+"^"+OrdExecDR;
	    	Para=Para+"^"+UpdateStatus+"^"+ServerObj.MapID;
	   	$.m({
			ClassName:"DHCDoc.DHCDocCure.Assessment",
			MethodName:"SaveCureAssBroker",
			Para:Para,
		    DCRowIDStr:ServerObj.DCRowIDStr
		},function(retVal){
	    	var value=retVal.split(String.fromCharCode(1))[0];
            var RowidStr=retVal.split(String.fromCharCode(1))[1];
            if ( UpdateObj.caIsPass==1){
	            CASignObj.SaveCASign(UpdateObj.CAObj, RowidStr, "CureAss");
	            $.m({
		            ClassName:"DHCDoc.DHCDocCure.Assessment",
					MethodName:"GetCAImage",
					AssRowId:RowidStr.split("^")[0]
	            },function(ret){
		            CAImage=ret
		        	setCAImage();
		        })
	            
            }
            ServerObj.DCAssRowId=RowidStr;
			if((value==0)||(value==""))
			{
				$("#CureAssPrt").removeClass('btn-lighttempgreen');
				$("#CureAssPrt").linkbutton('enable');
				if(typeof(window.parent.InvAssTempCallBack)=='function'){
					window.parent.InvAssTempCallBack(ServerObj.MapID);
				}
				if(ServerObj.PageShowFromWay!="ShowFromAPP"){
					$.messager.confirm('提示','是否打印本次提交保存的评估单?',function(r){
						if(r){
							CureAssPrt();
							$.messager.confirm('提示','是否关闭当前界面?',function(r){
								if(r){
									websys_showModal("close");
								}	
							});
						}else{
							$.messager.confirm('提示','是否关闭当前界面?',function(r){
								if(r){
									websys_showModal("close");
								}	
							});	
						}
					});
				}
			}else{
				errmsg='保存失败'+",错误代码:"+value
				$.messager.alert('错误',errmsg);
			}
        })
    })
}

function ConTroClick(){
	if(ServerObj.MapID==""){
		$("#BtnABNormalCure").removeClass('btn-lightred');
		$("#CureAssTempSave").removeClass('btn-lighttempgreen');
		$("#BtnNoEffectCure").removeClass('btn-lightSlateGray');
		$("#CureAssSave,#BtnBetterCure").removeClass('btn-lightgreen');
		$("#BtnNoEffectCure,#BtnBetterCure,#BtnNormalCure,#CureAssTempSave,#CureAssSave,#BtnABNormalCure,#CureAssPrt").linkbutton('disable');
	}
	else if((ServerObj.DCAssRowId=="")){
		$("#CureAssPrt").removeClass('btn-lighttempgreen');
		$("#CureAssPrt").linkbutton('disable');
	}
	else if((ServerObj.DCAssRowId!="")){ //&&(ServerObj.DCRUpdateStatus=="Y")
		$("#CureAssSave").linkbutton({text:"更新"});
		$("#CureAssPrt").removeClass('btn-lighttempgreen');
		$("#CureAssPrt").linkbutton('enable');
	}
}

function CheckforUpdate(){
	var CheckStr=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireItem",ServerObj.MapID);
	
	if (CheckStr!=""){
		var CheckAry=CheckStr.split("^")
		for (var i=0;i<CheckAry.length;i++) {
			var OneCheckStr=CheckAry[i]
			var ID=OneCheckStr.split(String.fromCharCode(1))[0]
			if ($("#"+ID).length > 0){
				if ($("#"+ID).hasClass('combobox-f')){
					var val = $HUI.combobox("#"+ID).getValue(); 
				}else if ($("#"+ID).hasClass('hisui-checkbox')){
					var  val=$("#"+ID).prop("checked");
				}else if ($("#"+ID).hasClass('hisui-timespinner')){
					var val = $HUI.timespinner("#"+ID).getValue(); 		
				}else if ($("#"+ID).hasClass('hisui-numberbox')){
					var val = $HUI.numberbox("#"+ID).getValue(); 		
				}else if ($("#"+ID).hasClass('hisui-datetimebox')){
					var val = $HUI.datetimebox("#"+ID).getValue(); 		
				}else if ($("#"+ID).hasClass('hisui-datebox')){
					var val = $HUI.datebox("#"+ID).getValue();
						//$HUI.datebox("#"+ID).setValue(Val);  		
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
	var CheckStrLenght=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireLength",ServerObj.MapID);
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
					$.messager.alert("提示",OneCheckStr.split(String.fromCharCode(1))[1]+"长度过长,限制长度:"+OneLength+",请重新填写!");
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
	} else if (className.indexOf("hisui-timespinner")>=0) {
		return "timespinner";
	} else if (className.indexOf("hisui-numberbox")>=0) {
		return "numberbox";
	} else {
		return "text";
	}
}

// 打印
function CureAssPrt(){
	assTempPrint.AssTemp_Print(ServerObj.DCAssRowId,ServerObj.MapDesc);
}


function LoaditemReqJsonStr(){
	if (itemReqJsonStr!=""){
		for (var i = 0; i < itemReqJsonStr.length; i++) {
			var OneReqJson=itemReqJsonStr[i]
			var ID=OneReqJson.ID
			var Val=OneReqJson.Val
			var Desc=OneReqJson.Desc
			if(Desc=="CMAssMR"){
				//debugger	
			}
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
				}else if ($("#"+ID).hasClass('hisui-timespinner')){
					$HUI.timespinner("#"+ID).setValue(Val); 		
				}else if ($("#"+ID).hasClass('hisui-numberbox')){
					$HUI.numberbox("#"+ID).setValue(Val); 		
				}else if ($("#"+ID).hasClass('hisui-radio')){
					//{"ID":"CBAssContraindications_No","Val":"CBAssContraindications_Yes","Class":"radio","Desc":"CBAssContraindications"}
					if(typeof Val != 'undefined'){
						$HUI.radio("#"+Val).setValue(true);	
					}else{
						//var $browsers = $("input[name="+Desc+"]");	
						//$browsers.removeAttr("checked");
						$HUI.radio("input[name="+Desc+"]").setValue(false);	
					}
				}else{
					$("#"+ID).val(Val)
				}
			}
        }
        setCAImage();
	}
}

function setCAImage(){
	if (CAImage!=""){
        $("#CAImage").attr("src",CAImage);
    }	
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
	var BLIDStrArry=ServerObj.BLIDStr.split("^");
	for (var i = 0; i < BLIDStrArry.length; i++) {
		$("#"+BLIDStrArry[i]).panel("resize",{width:$(window).width()-20});
	}
	setTimeout(function() { 
    	if ($(".window-mask").is(":visible")){
			$(".messager-window").css({'top':($(window).height()-100)/2,'left':($(window).width()-300)/2});
		}
    });
}

function TransLate(){
	var MapIDStrArr=ServerObj.BLIDStr.split("^")
	for (var i = 0; i < MapIDStrArr.length; i++) {
		var OneMapIDStr=MapIDStrArr[i];
		var OneMapID=OneMapIDStr.split(String.fromCharCode(1))[0];
		var $nodes=$("#"+OneMapID).find("label");
		for (var j=0; j< $nodes.length; j++){
			var domName = $nodes[j].innerText;
			if (domName == "") {continue;}
			$nodes[j].innerHTML=$g(domName); 
		}
	}
}

function setDefAssDate(ele){
	//默认当前时间,设置最大日期为当天
	$HUI.datetimebox('#'+ele).setValue(ServerObj.CurrentDateTime);
	var now = new Date();
	var opt = $('#'+ele).datebox('options');
	opt.maxDate = opt.formatter(now);
}
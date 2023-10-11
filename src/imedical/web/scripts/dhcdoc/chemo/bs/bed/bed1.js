/**
 * bed.js 门诊化疗床位管理
 * 
 * Copyright (c) 2020- QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-12-17
 * 
 * 
 */
var PageLogicObj = {
	v_DefaultDate:'',
	v_PatientID:''
	
}

$(function() {
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	PageHandle();
})


function Init(){
	InitGlobal();
	InitDate();
	LoadCard("AMCard","A");
	LoadCard("PMCard","P");
	SetPatBanner();
}

function InitEvent () {
	$("#Find").click(Find_Handle)
	$("#i-clean").click(Clean_Handle)
	$("#AM_Add_btn").click(function(){
		Add_Handle("A")	
	})
	$("#PM_Add_btn").click(function(){
		Add_Handle("P")	
	})
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle () {
	//SetToolBar();
}

function InitDate() {
	$("#ChemoDate").datebox({
		value:PageLogicObj.v_DefaultDate,
		editable:false,
		onSelect: function (date) {
			var curDate = $(this).datebox("getValue");
			Find_Handle();
		}
	})
	//$("#ChemoDate").datebox("setValue",result);
	
}
function InitGlobal () {
	var result = tkMakeServerCall("DHCDoc.Chemo.BS.Bed.Manage", "GetDefaultDate");
	PageLogicObj.v_DefaultDate = result;
	
}

function LoadCard(Selector,Type) {
	
	$m({
		ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
		MethodName:"LoadCard",
		SelectDate:$("#ChemoDate").datebox("getValue")||"",
		Type:Type
	}, function(result){
		_$dom = $(result);
		$("#"+Selector).empty();
		$("#"+Selector).append(_$dom);
		//$(".card").dblclick(Arrange_Handle)
	});
	
	/*
	var result = $m({
		ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
		MethodName:"LoadCard",
		SelectDate:$("#ChemoDate").datebox("getValue")||"",
		Type:Type
	},false);
	if (result!="") {
		_$dom = $(result);
		$("#"+Selector).empty();
		$("#"+Selector).append(_$dom);
	}
	*/
}

function SetPatBanner(PatNo) {
	PatNo = PatNo||"";
	
	var rowData = {
		patName: '',
		patSex: '',
		patAge: ''
	}
	
	if (PatNo != "") {
		var responseText = tkMakeServerCall("DHCDoc.Chemo.BS.Bed.Manage", "GetPatientInfoByPatNo", PatNo);
		//alert(responseText)
		if (responseText !="" ) {
			var mArr = responseText.split("^");
			PageLogicObj.v_PatientID = mArr[0];
			rowData.patName = mArr[1];
			rowData.patSex = mArr[3];
			rowData.patAge = mArr[2];
		}
	}
	
	if (rowData.patSex == "女") {
		$("#i-msg-pic").css("background","url('../csp/dhcdoc/chemo/img/bed/woman.png') 0% 0% / cover no-repeat")
	} else {
		$("#i-msg-pic").css("background","url('../csp/dhcdoc/chemo/img/bed/man.png') 0% 0% / cover no-repeat")
	}
	$("#i-msg-name").text(rowData.patName);
	$("#i-msg-sex").text(rowData.patSex);
	$("#i-msg-age").text(rowData.patAge);
}


//重置
function Clean_Handle () {
	$("#patNo").val("")
	PageLogicObj.v_PatientID = "";
	SetPatBanner();
}

//分配
function Arrange_Handle (bid) {
	bid = bid||"";
	if (PageLogicObj.v_PatientID=="") {
		$.messager.alert("提示", "请读取病人信息！", "info");
		return false;
	}
	if (bid=="") {
		$.messager.alert("提示", "无法获取床位信息！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认分配该床位么？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
				MethodName:"Arrange",
				//UserID:session['LOGON.USERID'],
				bid:bid,
				PatientID:PageLogicObj.v_PatientID
			}, function(result){
				var reArr=result.split("^")
				if (reArr[0] == 0) {
					$.messager.alert("提示", "分配成功！", "info");
					LoadCard(reArr[1]+"MCard",reArr[1]);
					return true;
				} else if (reArr[0] == -2) {
					$.messager.alert("提示", "病人已分配过床位！" , "info");
					return false;
				} else {
					$.messager.alert("提示", "分配失败：" + reArr[0] , "info");
					return false;
				}
			});
		}
		
	});
}

//删除
function Del_Handle (bid) {
	$.messager.confirm("提示", "确认删除该床位么？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
				MethodName:"Delete",
				//UserID:session['LOGON.USERID'],
				bid:bid
			}, function(result){
				var reArr=result.split("^")
				if (reArr[0] == 0) {
					/*$.messager.alert("提示", "删除成功！", "info",function () {
						LoadCard(reArr[1]+"MCard",reArr[1]);
					});*/
					LoadCard(reArr[1]+"MCard",reArr[1]);
					return true;
				} else {
					$.messager.alert("提示", "删除：" + result[0] , "info");
					return false;
				}
			});
		}
		
	});
		
}

//修改
function Edit_Handle (bid) {
	if (bid == "") {
		//$.messager.alert('提示','请选择病人！' , "warning");
		return false;
	}
	var src="chemo.bs.bed.arrange.csp?bid="+bid;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Edit_Handle","修改", 600, 400,"icon-w-edit","",$code,"");
}

//查询
function Find_Handle () {
	LoadCard("AMCard","A");
	LoadCard("PMCard","P");	
}

function Add_Handle (Type) {
	var SelectDate=$("#ChemoDate").datebox("getValue")||"";
	if (SelectDate=="") {
		$.messager.alert("提示", "请选择化疗日期！" , "info");
		return false;
	}
	$.messager.confirm("提示", "确认增加床位么？",function (r) {
		if (r) {
			
	
			$m({
					ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
					MethodName:"Add",
					//UserID:session['LOGON.USERID'],
					SelectDate:SelectDate,
					Type:Type
				}, function(result){
					if (result == 0) {
						$.messager.alert("提示", "添加成功！", "info");
						LoadCard(Type+"MCard",Type);
						return true;
					} else {
						$.messager.alert("提示", "添加失败：" + result , "info");
						return false;
					}
				});
		}
		
	});
	
	
	
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("patNo")>=0){
			var PatNo=$('#patNo').val();
			/*
			if ((PatNo.length<11)&&(PatNo!="")) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$('#patNo').val(PatNo);*/
			
			SetPatBanner(PatNo)
			return false;
		}
		return true;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}

function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' style='overflow:hidden;' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}

function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}	
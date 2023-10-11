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
	v_PatientID:'',
	v_MData:[],
	v_CardArr: {
		/*
		2:"2^PUMCH^就诊卡^C^N^^5^Y^N^61091^^IE^N^ReadCard^2^^Read^0^Y^N^Name^N^CardNo^Y^CL^UDHCCardInvPrt^DHCOutMedicalHome^Y^PC^^CQU^Y^Y^Y^^",
		3:"3^202^医保卡^NP^N^^0^Y^N^61091^^IE^N^CardNo^^^Handle^0^N^N^Name^Y^TelHome^N^CL^UDHCCardInvPrt^DHCOutMedicalHome^N^PC^^CQU^Y^Y^Y^^",
		4:"4^ICBC^工行银医卡^NP^N^^^Y^N^62378^^IE^N^ReadCard^2^^Read^19^N^N^Name^^CardNo^N^CL^^^Y^TC^^CQU^Y^Y^N^^",
		5:"5^305^健康卡^NP^N^^0^Y^N^62514^^IE^N^CardNo^3^^Handle^^N^N^Name^Y^TelHome^N^N^^DHCOutMedicalHome^N^PC^^CQU^N^N^N^^",
		6:"6^CCB^建行银医卡^NP^N^^^Y^N^62794^^IE^N^ReadCard^2^^Read^19^N^N^Name^^CardNo^N^CL^^^Y^TC^^CQU^Y^Y^N^^",
		7:"7^BOC^中行银医卡^NP^N^^^Y^N^62794^^IE^N^ReadCard^2^^Read^19^N^N^Name^^CardNo^N^CL^^^Y^TC^^CQU^Y^Y^N^^",
		8:"8^BOCM^交行银医卡^NP^N^^^Y^N^62794^^IE^N^ReadCard^2^^Read^19^N^N^Name^^CardNo^N^CL^^^Y^TC^^CQU^Y^Y^N^^",
		9:"9^ICBC-B^工行绑定卡^NP^N^^^Y^N^62794^^IE^N^ReadCard^^^Handle^^N^N^Name^^CardNo^N^CL^^^Y^TC^^CQU^Y^Y^N^^",
		10:"10^CCB-B^建行绑定卡^NP^N^^^Y^N^62794^^IE^N^ReadCard^^^Handle^^N^N^Name^^CardNo^N^CL^^^Y^TC^^CQU^Y^Y^N^^",
		11:"11^BOC-B^中行绑定卡^NP^N^^^Y^N^62794^^IE^N^ReadCard^^^Handle^^N^N^Name^^CardNo^N^CL^^^Y^TC^^CQU^Y^Y^N^^",
		12:"12^BOCM-B^交行绑定卡^NP^N^^^Y^N^62794^^IE^N^ReadCard^^^Handle^^N^N^Name^^CardNo^N^CL^^^Y^TC^^CQU^Y^Y^N^^",
		13:"13^IDCARD^二代身份证^NP^N^^0^Y^N^64727^^IE^N^ReadCard^2^^Read^18^N^N^Name^Y^CardNo^N^CL^UDHCCardInvPrt^DHCOutMedicalHome^N^PC^^CQU^Y^Y^Y^^",
		14:"14^QRCode^就医凭证^NP^N^^0^Y^Y^64964^^IE^N^Name^^^Read^^N^N^Name^Y^TelHome^N^CL^UDHCCardInvPrt^DHCOutMedicalHome^N^PC^^CQU^N^N^N^^"	,
		15:"15^ABC^农行银医卡^NP^N^^^Y^N^62528^^IE^N^ReadCard^2^^Read^19^N^N^Name^^CardNo^N^CL^^^Y^TC^^CQU^Y^Y^N^^",
		16:"16^ABC-B^农行绑定卡^NP^N^^^Y^N^62528^^IE^N^ReadCard^^^Handle^^N^N^Name^^CardNo^N^CL^^^Y^TC^^CQU^Y^Y^N^^",
		17:"17^ABC-B^农行卡^NP^N^^^Y^N^62794^^IE^N^ReadCard^^^Handle^^N^N^Name^^CardNo^N^CL^^^Y^TC^^CQU^Y^Y^N^^"
		*/
	},
	v_NAV: {"T-AM":0,"T-PM":0}	//PageLogicObj.v_NAV
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
	InitCombox();
	LoadCard("AMCard","A");
	LoadCard("PMCard","P");
	
}

function InitEvent () {
	$("#Find").click(Find_Handle)
	$("#i-clean").click(Clean_Handle)
	$("#ReadCard").click(ReadCard_Handle)
	$("#Scan").click(Scan_Handle)
	$("#GoTOP").click(Gotop_Handler)
	$("#AM_Add_btn").click(function(){
		Add_Handle("A")	
	})
	$("#PM_Add_btn").click(function(){
		Add_Handle("P")	
	})
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle () {
	CreateNavBar();
	if (HISUIStyleCode=="lite") {
		$("#i-title").removeClass("c-img-blue")
		$("#i-title").addClass("c-img-lite")
		
	} else {
		$("#i-title").removeClass("c-img-lite")
		$("#i-title").addClass("c-img-blue")
	}
}

function CreateNavBar() {
	$("#anchorList>li>a").mouseover(function(){
		$(this).animate({fontSize:"16px"},300);
		$(this).addClass("anchor-cur");
	});
	$("#anchorList>li>a").mouseout(function(){
		$(this).animate({fontSize:"14px"},300);
		$(this).removeClass("anchor-cur");
		
	});
	
	$("#anchorList>li>a").on('click', function(e){
		var tag = $(this).attr("data-taget");
		var top = $("#"+tag).position().top;
		$("#main-center").animate({scrollTop:top},200);
		ChangeNavStyle(tag);
		return false;
	})
	
	var result = $cm({
		ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
		MethodName:"GetAmOrPM",
		dataType:"text"
	},false);
	if (result=="PM") {
		$("#nac-T-PM").trigger("click");
	}
	
}

function ChangeNavStyle(cid) {
	for (var key in PageLogicObj.v_NAV) {
		if (key == cid) {
			$("#"+key).css({"color":"red"})
		} else {
			$("#"+key).css({"color":"#000"})
		}
	}
}

function DoNavHeight() {
	for (var key in PageLogicObj.v_NAV) {
		var top = $("#"+key).position().top;
		PageLogicObj.v_NAV[key]=top;
	}
}


function Gotop_Handler () {
	$("#main-center").animate({scrollTop:0},200);
	
}

function InitCombox() {
	PageLogicObj.m_CardType = $HUI.combobox("#CardType", {
		//url:$URL+"?ClassName=DHCDoc.Chemo.BS.Bed.Manage&QueryName=QryCardType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		data:PageLogicObj.v_MData,
		disabled:true,
		value:14,
		blurValidValue:true,
		onSelect: function (record) {
			
		}
	});
}

function InitDate() {
	$("#ChemoDate").datebox({
		value:PageLogicObj.v_DefaultDate,
		editable:false,
		onSelect: function (date) {
			var curDate = $(this).datebox("getValue");
			var compareFlag = tkMakeServerCall("DHCDoc.Chemo.BS.Bed.Manage", "CompareDate",curDate);
			if (compareFlag<0) {
				$(".BtnTD").css("display","none");
			} else {
				$(".BtnTD").css("display","block");	
			}
			Find_Handle();
		}
	})
	//$("#ChemoDate").datebox("setValue",result);
	
}
function InitGlobal () {
	var result = tkMakeServerCall("DHCDoc.Chemo.BS.Bed.Manage", "GetDefaultDate");
	PageLogicObj.v_DefaultDate = result;
	
	var result = tkMakeServerCall("web.UDHCOPOtherLB", "ReadCardTypeDefineListBroker","GetCardTypeToJson");
	var resultArr = [];
	if (result!="") {
		resultArr = eval('('+ result +')');
	}
	for (var i=0;i<resultArr.length;i++) {
		var mArr = resultArr[i];
		var desc = mArr[0];
		var info = mArr[1];
		var id = info.split("^")[0];
		var json = {
			id : id,
			desc: desc	
		};
		PageLogicObj.v_CardArr[id] = info;
		PageLogicObj.v_MData.push(json);
	}
	
	
}

function LoadCard(Selector,Type) {
	var result = $cm({
		ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
		MethodName:"LoadCard",
		SelectDate:$("#ChemoDate").datebox("getValue")||"",
		InHsop:session['LOGON.HOSPID'],
		Type:Type,
		dataType:"text"
	},false)
	
	if (result!="") {
		_$dom = $(result);
		$("#"+Selector).empty();
		$("#"+Selector).append(_$dom);
	}
}

function SetPatBanner(PatNo) {
	PatNo = PatNo||"";
	
	var rowData = {
		patName: '',
		patSex: '',
		patAge: ''
	}
	
	if (PatNo != "") {
		var responseText = tkMakeServerCall("DHCDoc.Chemo.BS.Bed.Manage", "GetPatientInfoByPatNo", PatNo,session['LOGON.HOSPID']);
		//alert(responseText)
		if (responseText !="" ) {
			var mArr = responseText.split("^");
			PageLogicObj.v_PatientID = mArr[0];
			rowData.patName = mArr[1];
			rowData.patSex = mArr[3];
			rowData.patAge = mArr[2];
		} else {
			$.messager.alert("提示", "患者不存在！" , "info");
			//return false;
		}
	}
	
	if (rowData.patSex == "女") {
		$("#i-msg-pic").css("background","url('../scripts/dhcdoc/chemo/img/bed/woman.png') 0% 0% / cover no-repeat")
		$("#i-msg-pic").attr("src","../scripts/dhcdoc/chemo/img/bed/woman.png")
	} else if (rowData.patSex == "男") {
		$("#i-msg-pic").css("background","url('../scripts/dhcdoc/chemo/img/bed/man.png') 0% 0% / cover no-repeat")
		$("#i-msg-pic").attr("src","../scripts/dhcdoc/chemo/img/bed/man.png")
	} else {
		//$("#i-msg-pic").css("background","url('../scripts/dhcdoc/chemo/img/bed/man.png') 0% 0% / cover no-repeat")
		$("#i-msg-pic").css("background","url('../scripts/dhcdoc/chemo/img/bed/unKnownAvatar.png') 0% 0% / cover no-repeat")
		$("#i-msg-pic").attr("src","../scripts/dhcdoc/chemo/img/bed/unKnownAvatar.png")
	}
	$("#i-msg-name").text(rowData.patName);
	$("#i-msg-sex").text(rowData.patSex);
	$("#i-msg-age").text(rowData.patAge);
	
}


//重置
function Clean_Handle () {
	$("#CardNo,#PatNo").val("")
	PageLogicObj.m_CardType.setValue(14);
	PageLogicObj.v_PatientID = "";
	SetPatBanner();
}

//分配
function Arrange_Handle (bid,PatientID) {
	bid = bid||"",
	PatientID=PatientID||"";
	
	if (PatientID!="") {
		$.messager.alert("提示", "该床位已经分配过！", "info");
		return false;
	}
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

//清空
function Reset_Handle (bid) {
	$.messager.confirm("提示", "确认清空该床位么？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
				MethodName:"ResetBed",
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
					$.messager.alert("提示", "清空失败：" + result[0] , "info");
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
function Edit_Handle (bid,PatientID) {
	if (bid == "") {
		//$.messager.alert('提示','请选择病人！' , "warning");
		return false;
	}
	//alert(PatientID)
	var ChemoDate = $("#ChemoDate").datebox("getValue")||"";
	if (ChemoDate=="") {
		$.messager.alert('提示','请选择化疗日期！' , "warning");
		return false;
	}
	var src="chemo.bs.bed.arrange.csp?bid="+bid+"&PatientID="+PatientID+"&ChemoDate="+ChemoDate;
        if ('undefined'!==typeof websys_getMWToken){
                src += "&MWToken="+websys_getMWToken()
        }
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Edit_Handle","关联", 600, 400,"icon-w-edit","",$code,"");
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

function Scan_Handle() {
	var myCardTypestr=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myCardTypeValue=""
	
	var CardTypeDR=PageLogicObj.m_CardType.getValue()||"";
	var myCardTypestr = PageLogicObj.v_CardArr[CardTypeDR]
	
	if(myCardTypestr!="") { 
	  var myCardTypearr=myCardTypestr.split("^");
	  myCardTypeValue=myCardTypearr[0];
	}
	
	var myrtn=DHCACC_Scan("PatNo","CardNo",myCardTypeValue);
    if (myrtn==-200) {              
       alert("读卡失败,返回值:"+myrtn) ;
       return;
     }
	var myary=myrtn.split("^");
	var SelectedCardType=myary[8];
	var rtn=myary[0];

	
	if (rtn=="-1") {
		alert("不能读卡,返回值:"+rtn);
		return ;
	} else {	
			var obj=document.getElementById("PatNo");
			if (obj) obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			if (obj) obj.value=myary[1];
			PageLogicObj.m_CardType.setValue(SelectedCardType);
			SetPatBanner(myary[5]);
	} 
}

function ReadCard_Handle() {
	var CardTypeDR=PageLogicObj.m_CardType.getValue()||"";
	var myEquipDR = PageLogicObj.v_CardArr[CardTypeDR]
	//alert(myEquipDR)
	//var myEquipDR=combo_CardType.getActualValue();
   var CardInform=DHCACC_GetAccInfo(CardTypeDR,myEquipDR)
   //alert(CardInform)
   var CardSubInform=CardInform.split("^");
   //alert(CardInform)
   var rtn=CardSubInform[0];
   var SelectedCardType=CardSubInform[8];
	var CardNo=CardSubInform[1];
	//alert("CardNo: "+CardNo)
	//var ret=CheckIfUnite(CardNo,"");
    //alert(rtn)
    switch (rtn){
			case "-200": //卡无效
				alert("卡无效");
				clearScreen();
				break;
			default:
				//alert(myrtn)
				document.getElementById('CardNo').value=CardSubInform[1];
				document.getElementById('PatNo').value=CardSubInform[5];
				//alert(document.getElementById('CardNo').value=CardSubInform[1])
				PageLogicObj.m_CardType.setValue(SelectedCardType);
				SetPatBanner(CardSubInform[5]);
				//DHCWeb_SetListDefaultValue("CardTypeDefine",SelectedCardType,"^",0);
				break;
		}
    
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
	//alert(keyCode)
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("PatNo")>=0){
			var PatNo=$('#PatNo').val();
			
			if ((PatNo.length<11)&&(PatNo!="")) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$('#PatNo').val(PatNo);
			
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
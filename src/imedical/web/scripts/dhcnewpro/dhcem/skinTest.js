// Creator: congyue
/// CreateDate: 2016-08-11
///  Descript: 皮试
var LINK_CSP="dhcapp.broker.csp";
var methodSel = [{ "id": "1", "text": $g("静注法") }, { "id": "2", "text": $g("结膜试验法") },{ "id": "3", "text": $g("点（挑）刺") }, { "id": "4", "text": $g("口含试验法") },{ "id": "5", "text": "划痕法" },{ "id": "6", "text": "皮内试验法" }, { "id": "7", "text": $g("点眼法") }];
$(document).ready(function() {
	
	initSetPage(); ///通过配置显示界面

	initPageValue();
	
	initMethod();
	
	if (Allgryflag==1){ //2016-10-27 控制提示语句显示
		$('#allergymess').show();
	}
  	
	//复选框分组
	InitUIStatus();
	
	 //皮试方法
	$('#TestMethodSel').combobox({
		valueField:'id',
		textField:'text',
		data:methodSel
	});  
		 	
	
	
    $('#skinTesttb').datagrid({
	    fit:true,
	    toolbar:[],//hxy 2023-01-05 st
	    title:$g('PPD记录'),
	    iconCls:"icon-paper",
	    headerCls:'panel-header-gray',
	    border:true, //false //ed
	    pageSize:999,
	    pageList:[999],
	    pagination:true,
        idField: 'id',
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMSkinTest&MethodName=ListPatHis&Ordid='+oeoreId,
        columns: [[{
            checkbox: true
        },{
			field: 'TestSkinSity',
			title: '皮肤硬结',
			align: 'center'
		}, {
			field: 'TestSkinVcl',
			title: '局部水泡',
			align: 'center'
		}, {
			field: 'TestSkinSwo',
			title: '红肿',
			align: 'center'
		}, {
			field: 'TestSkinNecrosis',
			title: '坏死',
			align: 'center'
		}, {
			field: 'TestSkinInflam',
			title: '淋巴管炎',
			align: 'center'
		}, {
			field: 'TestSkinSing',
			title: '单个',
			align: 'center'
		},{
			field: 'TestSkinSpora',
			title: '散在',
			align: 'center'
		}, {
			field: 'EpisodeID',
			title: '就诊id',
			align: 'center'
		}, {
			field: 'oeorid',
			title: '医嘱id',
			align: 'center'
		},{
			field: 'TestDate',
			title: '日期',
			align: 'center'
		}, {
			field: 'TestTime',
			title: '时间',
			align: 'center'
		}, {
			field: 'TestUser',
			title: '记录人',
			align: 'center'
		}, {
			field: 'id',
			title: 'id',
			align: 'center'
		}, {
			field: 'PDDResult',
			title: 'PPD结果',
			align: 'center'
		}
		]]
    });
	$("#ObserveDefine").focus(function(){
		//$("input[type=radio][name=ObserveTime]").attr("checked",false);
		$("input[name=ObserveTime]").radio('setValue',false)
	});
});

function initMethod(){
	$("#skinSize").on("keypress",skinSizePress);
	
	$("#pddDiv").find("input").on('keyup',function(){	
		getPPD();	
	})
	
	$("#AN10").on("click",function(){
		getPPD();
	})
	
	$("#AN11").on("click",function(){
		getPPD();
	})
	
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
		});
	});
	
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
		});
	});
	
	//当皮试时间勾选时，清空皮试时间输入框
	$HUI.radio("[name='ObserveTime']",{
        onChecked:function(e,value){
		   $('#ObserveDefine').val("");
        }
  	});
 	/*/当皮试时间勾选时，清空皮试时间输入框
     $("input[type=checkbox][name=ObserveTime]").click(function(){
		if($(this).is(':checked')){
			$('#ObserveDefine').val("");
		}
	});*/
}

function initPageValue(){
	runClassMethod(
	"web.DHCEMSkinTest", 
	"GetSkinRsData", 
	{'oeoriId':oeoreId}, 
	function(data){
	 	var pddRs = data.split("#")[0];
	 	var skinInfo = data.split("#")[1];
	 	if(pddRs==0){
		 	$HUI.radio('#AN0').setDisable(true);
			$HUI.radio('#AN1').setDisable(true);
		 	$("#pddDiv").find("input").attr("disabled",true)
		}else{
		 	//$("#sTR0").attr("disabled",true)
			//$("#sTR1").attr("disabled",true)
			$HUI.radio('#sTR0').setDisable(true);
			$HUI.radio('#sTR1').setDisable(true);
		}
		
		if((skinInfo!="")&&(skinInfo!=undefined)){
			
			var ret="";
			var skinInfoArr = skinInfo.split("^");
			var skinRsDesc =skinInfoArr[3];
			ret = $g("当前皮试结果")+":"+skinRsDesc+"  "+$g("皮试人")+":"+skinInfoArr[4]+"  "+$g("复核人")+":"+skinInfoArr[8];
			$("#skinRs").html(ret);
		}
	},"text",false);	
}


function opFormatter(value, rowData){
	return "<button class='btn btn-xs btn-danger btn-labeled fa fa-remove' type='button'  onclick='removeBTN(this);' data-Id='"+rowData.id+"'  >"+$g("删除")+"</button>" 
}
function removeBTN(obj){
	id=$(obj).attr("data-Id");
	dhccBox.confirm("提示","确认要删除吗?","",function(){
			runClassMethod(
				"web.DHCEMSkinTest", 
				"remove", 
				{'id':id}, 
				function(data){ //2016-10-26
				 	$('#skinTesttb').dhccQuery()   //默认显示第一页
				});
	})
	
}	
function InitUIStatus()
{
	var tmpid="";
	$("input[type=checkbox]").click(function(){
		tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
				}
			})
		}
	});
}
 
function StartSkinTest() {	
	var count = 0;
	var TestAdmDr =adm,TestOeoriDr = oeoreId;//"420||2"; //就诊id  医嘱id TestAdmDr = "455"  TestOeoriDr = "420||2"
	
	var TestMethod = $("#TestMethodSel").combobox("getText");
    var _data = $("#TestMethodSel").combobox('getData');/* 下拉框所有选项 */
    var _b = false;/* 标识是否在下拉列表中找到了用户输入的字符 */
    for (var i = 0; i < _data.length; i++) {
        if (_data[i].text == TestMethod) {
            _b=true;
            break;
        }
    }
    if(!_b){
        TestMethod="";
    }
    if(TestMethod==""){
        $.messager.alert("提示","请选择皮试方法");
        return;
    }
	
	data=serverCall("web.DHCEMSkinTest", "TestPayMoney", { 'oriOreId':TestOeoriDr})
	if (data!= "") {
			$.messager.alert("提示",data)
			return;
	}
	
	if (TestOeoriDr != "") {
		var tmpTestOeoriDr = TestOeoriDr.split("||");
		TestOeoriDr = tmpTestOeoriDr[0] + "!!" + tmpTestOeoriDr[1];
	}
	var userId =LgUserID; //session['LOGON.USERID'];
	var locId =LgCtLocID; //session['LOGON.CTLOCID'];
	var ObserveTime = GetObserveTime();
	if (ObserveTime == "") {
		$.messager.alert("提示","时间为空")
		return;
	}
	var TestMethod = $("#TestMethodSel").combobox("getText");
	//var TestMethod=$("#TestMethodSel").dhccSelectM('data')[0].text;
	var parr = "TestAdmDr|" + TestAdmDr + "^TestStartDate|" + "^TestStartTime|" + "^RecUser|" + userId + "^TestOeoriDr|" + TestOeoriDr + "^ObserveTime|" + ObserveTime + "^TestLocDr|" + locId + "^TestMethod|" + TestMethod;
	runClassMethod( "web.DHCEMSkinTest", "Save", { 'id':'','parr':parr,'typ':'count'}, function(data){
		if (data != "0") {
			$.messager.alert("提示",data);
			return;
		}
		if (data == "0") {
			//window.opener.searchPatTest();
			if(window.parent.frames["TRAK_main"]){ //hos
				if(typeof window.parent.frames["TRAK_main"].searchPatTest ==="function"){
					window.parent.frames["TRAK_main"].searchPatTest();
				}
			}
//			if(window.top.frames[0]){
//				if(typeof window.top.frames[0].searchPatTest ==="function"){
//					window.top.frames[0].searchPatTest();
//				}
//			}
			
			$.messager.alert("提示","计时成功!","info",function(){
				window.top.websys_showModal("close");
			});	
		}
	},"json","true");
}

function GetObserveTime() {
	var retTime = "";
	var ObserveTime ="";
    $("input[name=ObserveTime]").each(function(){
		if($(this).is(':checked')){
			ObserveTime =this.value;
		}
	})
	//分钟时长
	var ObserveDefine=$('#ObserveDefine').val();
	if (ObserveTime=="0"){retTime = "10分钟";maxtime=10*60;}
	if (ObserveTime=="1"){retTime = "15分钟";maxtime=15*60;}
	if (ObserveTime=="2"){retTime = "20分钟";maxtime=20*60;}
	if (ObserveTime=="3"){retTime = "48小时";maxtime=48*60*60;}
	if (ObserveTime=="4"){retTime = "72小时";maxtime=72*60*60;}
	if (ObserveTime=="5"){retTime = "30分钟";maxtime=30*60;}
	if ((ObserveDefine>0)&&(isNaN(ObserveDefine)==false)){retTime = ObserveDefine+ "分钟";maxtime=ObserveDefine*60;}
	return retTime;
}
function butUpdateFn() {

	var count = 0,oeoriStr = oeoreId;//"420||2";
	var TestAdmDr =adm,TestOeoriDr = oeoreId;//"420||2"; //就诊id  医嘱id TestAdmDr = "455"  TestOeoriDr = "420||2"
	if (TestOeoriDr != "") {
		var tmpTestOeoriDr = TestOeoriDr.split("||");
		TestOeoriDr = tmpTestOeoriDr[0] + "!!" + tmpTestOeoriDr[1];
	}

	data=serverCall("web.DHCEMSkinTest", "IfPatPSEnd", { 'Adm':TestAdmDr,'oeoriId':oeoriStr})
	 if (data == "1") {
			$.messager.alert("提示","时间未到不能置皮试结果")
			return;
	}

	var skinTest = "",
		skinNote = "";
	//皮试结果：Y 阳性  N 阴性
	var skinTest ="";
    $("input[name=skinTestResult]").each(function(){
		if($(this).is(':checked')){
			skinTest =this.value;
		}
	})

	var IfPPDOrder = 0,GetIfPPDOrder="";

	GetIfPPDOrder=serverCall("web.DHCEMSkinTest", "GetIfPPDOrder", { 'oeoriId':oeoriStr})
	if (GetIfPPDOrder) {
		IfPPDOrder=	serverCall("web.DHCEMSkinTest", "GetIfPPDOrder", { 'oeoriId':oeoriStr})
	}
	if ((IfPPDOrder == 0) && (skinTest == "")) { //2016-10-27
			$.messager.alert("提示","请选择皮试结果");
			return;
	} 

	//取PPD试验结果
    //皮肤硬结 大小
    var AbnormalNoteText1=$('#AbnormalNoteText1').val(); 
    var AbnormalNoteText2=$('#AbnormalNoteText2').val(); 
	if ((AbnormalNoteText1!= "") || (AbnormalNoteText2!= "")) {
		var skinNote ="皮肤硬结"; //objcAbnormalNote.innerText;
		if (AbnormalNoteText1!= "") skinNote = skinNote + " " + AbnormalNoteText1 + "mm";
		if (AbnormalNoteText2 != "") skinNote = skinNote + "*" + AbnormalNoteText2 + "mm";
		if (skinNote != "") skinNote = skinNote + ";";
	}

    //局部水泡 大小
    var AbnormalNote1Text1=$('#AbnormalNote1Text1').val(); 
    var AbnormalNote1Text2=$('#AbnormalNote1Text2').val(); 
	if ((AbnormalNote1Text1!= "") || (AbnormalNote1Text2!= "")) {
		var skinNote = skinNote + " " +"局部水泡";//+ " " + objcAbnormalNote1.innerText;
		if (AbnormalNote1Text1!= "") skinNote = skinNote + " " + AbnormalNote1Text1 + "mm";
		if (AbnormalNote1Text2!= "") skinNote = skinNote + "*" + AbnormalNote1Text2 + "mm";
		//水泡分布  0 单个   1  散在    
		var AbnormalNote ="";
	    $("input[name=AbnormalNote]").each(function(){
			if($(this).is(':checked')){
				AbnormalNote =this.value;
			}
		})
		var AbnormalNotetext=""
		if (AbnormalNote==0){
			AbnormalNotetext="单个";
			skinNote = skinNote + " " + AbnormalNotetext;
		}
		if (AbnormalNote==1){
			AbnormalNotetext="散在";
			skinNote = skinNote + " " + AbnormalNotetext;
		}
		if (skinNote != "") skinNote = skinNote + ";";
	}

    //红肿   0 坏死   1  淋巴管炎    
	var AbnormalNote2 ="",AbnormalNote3 ="";
    $("input[type=checkbox][name=AbnormalNote2]").each(function(){
		if($(this).is(':checked')){
			AbnormalNote2 =this.value;
		}
	})

    $("input[type=checkbox][name=AbnormalNote3]").each(function(){
		if($(this).is(':checked')){
			AbnormalNote3 =this.value;
		}
	})

	var AbnormalNote2text="",AbnormalNote3text="";
	if (AbnormalNote2==10){
		AbnormalNote2text="坏死"; //坏死
		skinNote = skinNote + " " + AbnormalNote2text; 
		if (skinNote != "") skinNote = skinNote + ";";
	}
	if (AbnormalNote3==11){
		AbnormalNote3text="淋巴管炎"; //淋巴管炎
		skinNote = skinNote + " " + AbnormalNote3text;
		if (skinNote != "") skinNote = skinNote + ";";
	}

    //红肿 大小
    var AbnormalNote4Text1=$('#AbnormalNote4Text1').val(); 
    var AbnormalNote4Text2=$('#AbnormalNote4Text2').val(); 
	if ((AbnormalNote4Text1!= "") || (AbnormalNote4Text2!= "")) {
		var skinNote = skinNote + " " + "红肿";//+ " " + objcAbnormalNote4.innerText;
		if (AbnormalNote4Text1!= "") skinNote = skinNote + " " + AbnormalNote4Text1 + "mm";
		if (AbnormalNote4Text2!= "") skinNote = skinNote + "*" + AbnormalNote4Text2+ "mm";
		if (skinNote != "") skinNote = skinNote + ";";
	}

	var TestResult = "";
	if (skinTest == "Y") TestResult = "(+)";
	if (skinTest == "N") TestResult = "(-)";
	//PPD试验结果判读/自动置皮试阴阳性
	
	if (IfPPDOrder == 1) {
		if (skinNote != "") {
			TestResult = $("#PPDResult").val() //GetPPDStandard(skinNote, AbnormalNoteText1);
			if (TestResult == "(-)") {skinTest = "N"}
			else {skinTest = "Y"};
		} else {
			$.messager.alert("提示","请选择PPD试验结果");
			return;
		}
	}

	data=serverCall("web.DHCEMSkinTest", "IfPatPSEnd", { 'Adm':TestAdmDr,'oeoriId':oeoriStr})
	if (Number(data)==1) {
			$.messager.alert("提示","时间未到不能置皮试结果")
			return;
	}

	//皮试用户
	var userCode =$('#userCode').val();
	var passWord = $('#passWord').val();
	//复核用户
	var userCodeAudit = $('#userCodeAudit').val();
	var passWordAudit = $('#passWordAudit').val();
	
	var skinUserID ="",skinUserCode="";    ///不需要签名的取当前登录科室
	var skinAuditUserID ="",skinAuditUserCode="";
	if(SKINNEEDSIGN==1){   ///为1表示需要签名
		if (userCode == "") {
			$.messager.alert("提示","请输入皮试用户");
			return;
		}
		if (passWord == "") {
			$.messager.alert("提示","请输入皮试用户密码");
			return;
		}
		if((SKINSIGNNUM==2)){
			if (userCodeAudit == "") {
				$.messager.alert("提示","请输入复核用户");
				return;
			}
			if (passWordAudit == ""){
				$.messager.alert("提示","请输入复核用户密码");
				return;
			}
			if(SKINSINGTWOUSER!=1){
				if(userCode.toUpperCase()==userCodeAudit.toUpperCase()){
					$.messager.alert("提示","皮试用户和复核用户不允许为同一人");
					return;
				}	
			}
		}
		data=serverCall("web.DHCEMSkinTest", "ConfirmPassWord", { 'userCode':userCode,'passWord':passWord,'LocId':LgCtLocID})
		if (data.split("^")[0] != 0) {
			$.messager.alert("提示","皮试用户:" + data);
			return;
		} else {
			skinUserID = data.split("^")[1];   ///这个就是用户ID
			skinUserCode=userCode;
		}
		if(SKINSIGNNUM==2){
			data=serverCall("web.DHCEMSkinTest", "ConfirmPassWord", { 'userCode':userCodeAudit,'passWord':passWordAudit,'LocId':LgCtLocID})
			if (data.split("^")[0] != 0) {
				$.messager.alert("提示","复核用户:" + data);
				return;
			}else{
				skinAuditUserID = data.split("^")[1];   ///这个就是审核用户ID
				skinAuditUserCode=userCodeAudit;
			}
		}else{
			skinAuditUserID=LgUserID;
			skinAuditUserCode=LgUserCode;
		}
	}else{
		skinUserID = LgUserID;   ///这个就是用户ID
		skinUserCode=LgUserCode;
		skinAuditUserID=LgUserID;
		skinAuditUserCode=LgUserCode;
	}
	
	
	///皮试批次
	var skinSize = $('#skinSize').val();
	if((ISSHOWATTACH==2)&&(skinSize=="")){
		$.messager.alert("提示","请填写皮试批号");
		return;
	}
	if(skinSize!=""){
		skinSize =$g("批号")+":"+skinSize;
		//skinNote=skinNote==""?skinSize:skinSize+";"+skinNote; 
	}
	
	var savePDDInfo=getPDDDataInfo();

	var parObj={
		'oriOreId':oeoriStr,
		'userId':skinUserID,
		'skinUserCode':skinUserCode,
		'skinRecUserCode':skinAuditUserCode,
		'passWordAudit':passWordAudit,
		'flag':skinTest,
		'skinNote':skinNote,
		'RegNo':RegNo,
		'savePDDInfo':savePDDInfo,
		'IfPPDOrder':IfPPDOrder,
		'skinSize':skinSize,
		'lgParams':LgParams
	}
	
	//置皮试结果
	var retStr ="";
	retStr=serverCall( "web.DHCEMSkinTest","SetSkinTestResultXH",parObj);
	
	if (retStr == "0") {
		$.messager.alert("提示","操作成功！","info",function(){
			window.close()
		});
		
		if(parent.top.frames[0]!==undefined){
			parent.top.frames[0].searchPatTest();
			parent.top.frames[0].refreshAllergy(oeoriStr);
			parent.top.frames[0].frames[0].search();
			parent.top.frames[0].websys_showModal("close");
		}
		
	 } else {
		$.messager.alert("提示",retStr);
		return;
	} 

}

function getPDDDataInfo() {
	var userId = LgUserID;
	var oeoriStr = oeoreId;//"420||2";
	var TestAdmDr =adm,TestOeoriDr = oeoreId;//"420||2"; //就诊id  医嘱id TestAdmDr = "455"  TestOeoriDr = "420||2"
	if (TestOeoriDr != "") {
		var tmpTestOeoriDr = TestOeoriDr.split("||");
		TestOeoriDr = tmpTestOeoriDr[0] + "!!" + tmpTestOeoriDr[1];
	}
	// w ##class(web.DHCEMSkinTest).GetIfPPDOrder("343||15||1")
    //皮肤硬结 大小
    var TestSkinSityOne=$('#AbnormalNoteText1').val(); 
    var TestSkinSityTwo=$('#AbnormalNoteText2').val(); 
    //局部水泡 大小
    var TestSkinVclOne=$('#AbnormalNote1Text1').val(); 
    var TestSkinVclTwo=$('#AbnormalNote1Text2').val(); 
	//水泡分布  0 单个   1  散在    
	var AbnormalNote ="",TestSkinSing="",TestSkinSpora="";
    $("input[name=AbnormalNote]").each(function(){
		if($(this).is(':checked')){
			AbnormalNote =this.value;
		}
	})
	var AbnormalNotetext=""

	if (AbnormalNote==0){
		TestSkinSing="1";
	}
	if (AbnormalNote==1){
		TestSkinSpora="1";
	}
	if(AbnormalNote==""){
		TestSkinSing="";   //QQA 2017-02-16
		TestSkinSpora=""
		}
	
    //红肿   0 坏死   1  淋巴管炎    
	var AbnormalNote2 ="",AbnormalNote3 ="";
    $("input[type=checkbox][name=AbnormalNote2]").each(function(){
		if($(this).is(':checked')){
			AbnormalNote2 =this.value;
		}
	})
    $("input[type=checkbox][name=AbnormalNote3]").each(function(){
		if($(this).is(':checked')){
			AbnormalNote3 =this.value;
		}
	})
	var AbnormalNote2text="",AbnormalNote3text="",TestSkinNecrosis="",TestSkinInflam="";
	if (AbnormalNote2==10){
		TestSkinNecrosis="1"; //坏死
	}
	if (AbnormalNote3==11){
		TestSkinInflam="1"; //淋巴管炎
	}
    //红肿 大小
    var TestSkinSwoOne=$('#AbnormalNote4Text1').val(); 
    var TestSkinSwoTwo=$('#AbnormalNote4Text2').val(); 
	var PPDResult=$("#PPDResult").val();
	//if ((TestSkinSityOne == "") && (TestSkinVclOne == "") && (TestSkinSwoOne == "") && (TestSkinNecrosis == "") && (TestSkinInflam == "") && (TestSkinSing == "") && (TestSkinSpora == "")) return;
	var parr = "TestAdmDr|" + TestAdmDr + "^TestDate|" + "^TestTime|" + "^RecUser|" + userId + "^TestOeoriDr|" + TestOeoriDr + "^TestSkinSityOne|" + TestSkinSityOne + "^TestSkinSityTwo|" + TestSkinSityTwo + "^TestSkinVclOne|" + TestSkinVclOne + "^TestSkinVclTwo|" + TestSkinVclTwo + "^TestSkinSwoOne|" + TestSkinSwoOne + "^TestSkinSwoTwo|" + TestSkinSwoTwo + "^TestSkinNecrosis|" + TestSkinNecrosis + "^TestSkinInflam|" + TestSkinInflam + "^TestSkinSing|" + TestSkinSing + "^TestSkinSpora|" + TestSkinSpora+ "^PPDResult|" + PPDResult;;
	
	return parr;
}
/// PPD皮试结果判读标准
function GetPPDStandard(AbnormalNote, AbnormalNoteText1) {
	var retStr = "";
	if (AbnormalNote.indexOf("皮肤硬结") > -1) {
		AbnormalNoteText1 = eval(AbnormalNoteText1);
		if (AbnormalNoteText1 < 5) retStr = "(-)";
		if ((AbnormalNoteText1 >= 5) && (AbnormalNoteText1 < 10)) retStr = "(+)";
		if ((AbnormalNoteText1 >= 10) && (AbnormalNoteText1 < 20)) retStr = "(++)";
		if (AbnormalNoteText1 >= 20) retStr = "(+++)";
	}
	if ((AbnormalNote.indexOf("局部水泡") > -1) || (AbnormalNote.indexOf("坏死") > -1) || (AbnormalNote.indexOf("淋巴管炎") > -1)) {
		retStr = "(++++)";
	}
	return retStr;
}

//完成就诊
/*function CompleteRecAdm(){
	// modal remove
	$("#myModal").draggable({   
		handle: ".modal-header",   
		cursor: 'move',   
		refreshPositions: false  
    });  
	$('#myModal').modal('show');
	//$("#btn-modal-Comfirm").focus();//


	return false;
	var _content = "完成就诊"
	$.messager.model = { 
	    ok:{ text: "是", classed: 'btn-default' },
	    cancel: { text: "否", classed: 'btn-error' }
	};
	$.messager.confirm("提示", "是否完成就诊?", function() { 
	    $.messager.$.messager.alert("提示","完成就诊啦!");
	});
}*/
function getPPD(){

	try{
		retStr="";

		value=$('#AbnormalNoteText1').val();
		//皮肤硬结
		if($.trim(value)!=""){
			if (value < 5) retStr = "(-)";
			if ((value >= 5) && (value < 10)) retStr = "(+)";
			if ((value >= 10) && (value < 20)) retStr = "(++)";
			if (value >= 20) retStr = "(+++)";
		}
		value=$('#AbnormalNoteText2').val();
		//皮肤硬结
		if($.trim(value)!=""){
			if (value < 5) retStr = "(-)";
			if ((value >= 5) && (value < 10)) retStr = "(+)";
			if ((value >= 10) && (value < 20)) retStr = "(++)";
			if (value >= 20) retStr = "(+++)";
		}
		
		if(($("#AN0").is(':checked'))||($("#AN1").is(':checked'))||($("#AN10").is(':checked'))||($("#AN11").is(':checked'))){
			retStr = "(++++)";
		}
		//局部水泡 AbnormalNote1Text
		value=$('#AbnormalNote1Text1').val();
		if(($.trim(value)!="")&&($.trim(value)!=0)){
				retStr = "(++++)";
		}
		value=$('#AbnormalNote1Text2').val();
		if(($.trim(value)!="")&&($.trim(value)!=0)){
				retStr = "(++++)";
		}
		//坏死 AbnormalNote4Text
		value=$('#AbnormalNote4Text1').val();
		if(($.trim(value)!="")&&($.trim(value)!=0)){
				retStr = "(++++)";
		}
		value=$('#AbnormalNote4Text2').val();
		if(($.trim(value)!="")&&($.trim(value)!=0)){
				retStr = "(++++)";
		}

		$("#PPDResult").val(retStr)
		//$("#sTR1").prop("checked",false)
		//$("#sTR0").prop("checked",false)
		$HUI.radio('#sTR0').setValue(false);
		$HUI.radio('#sTR1').setValue(false);
		if(retStr!=""){
			if("(-)"==retStr){
				//$("#sTR1").prop("checked",true)
				$HUI.radio('#sTR1').setValue(true);
			}else{
				//$("#sTR0").prop("checked",true)
				$HUI.radio('#sTR0').setValue(true);
			}
		}
		
		if($("#AN10:checked").length){
			retStr = "(++++)";
		}
		
		if($("#AN11:checked").length){
			retStr = "(++++)";
		}
	}catch(err){
		
	}
}

function valiNumber(){
	even = event||{};
	var reg = /^\d+(\.\d+)?$/;
	var num = $(even.target).val();	
	if((num!="")&(!reg.test(num))){
		$(even.target).val("");
		$(even.target).focus();
	}
}

function initSetPage(){
	if((ISSHOWATTACH==1)||(ISSHOWATTACH==2)){
		$(".skinSizeItm").show();	
	}
	
	if(SKINNEEDSIGN!=1){
		$("#userCode").attr("disabled",true);
		$("#passWord").attr("disabled",true);
		$("#userCodeAudit").attr("disabled",true);
		$("#passWordAudit").attr("disabled",true);
		$("#userCode").val($g("不需签名"));
		$("#passWord").val($g("不需签名"));
		$("#userCodeAudit").val($g("不需签名"));
		$("#passWordAudit").val($g("不需签名"));
	}else{
		$('#userCode').val(LgUserCode);	
	}
	if(SKINSIGNNUM!=2){
		$("#userCodeAudit").attr("disabled",true);
		$("#passWordAudit").attr("disabled",true);
		$("#userCodeAudit").val($g("不需复核"));
		$("#passWordAudit").val($g("不需复核"));

	}
	$.m({ClassName:"web.DHCEMSkinTest",MethodName:"GetOrderInfo",OrdItmID:oeoreId},function(retData){
		if (retData!=""){
			retDataArr=retData.split("^");
			$("#arciDesc").html($g("当前医嘱名称")+"："+retDataArr[0]);
			var skinRs=retDataArr[1];
			if(skinRs!=""){
				$HUI.linkbutton("#btnStartSkinTest").disable();
				$("#btnStartSkinTest").attr("title","已经出结果,不允许再次计时!");
				if(skinRs=="Y"){
					//$("#sTR0").attr("checked","checked");
					$HUI.radio('#sTR0').setValue(true);
				}else{
					//$("#sTR1").attr("checked","checked");
					$HUI.radio('#sTR1').setValue(true);
				}
			}
			var ObserveTime=retDataArr[2];
			var TestMethod=retDataArr[3];
			if(TestMethod!=""){
				$("#TestMethodSel").combobox("setText",TestMethod);	
			}
			if(ObserveTime!=""){
				$("#ObserveDefine").val(parseFloat(ObserveTime));	
			}
			var ExecStatus=retDataArr[4];
			if(ExecStatus=="Y"){
				//$HUI.linkbutton("#updateBtn").disable();
				//$("#userCode").attr("disabled",true);
				//$("#passWord").attr("disabled",true);
				//$("#userCodeAudit").attr("disabled",true);
				//$("#passWordAudit").attr("disabled",true);
				//$("#userCode").val(retDataArr[6]);
				//$("#passWord").val(retDataArr[8]);
				//$("#userCodeAudit").val(retDataArr[7]);
				//$("#passWordAudit").val(retDataArr[9]);
			}
			var SkinSize=retDataArr[5];
			$("#skinSize").val(SkinSize.replaceAll("批号:",""));
		}
	});
	
	
	return;
}




function skinSizePress(e){
	if(e.keyCode==13){
		///皮试批次
		var skinSize = $('#skinSize').val();
		skinSize =$g("批号")+":"+skinSize;
		//if((ISSHOWATTACH==1)&&(SKINNEEDPCMUST==1)&&(skinSize=="")){
		if(((ISSHOWATTACH==1)||(ISSHOWATTACH==2))&&(skinSize=="")){
			$.messager.alert("提示","皮试批次不能为空！");
			return;
		}
		$cm({
			ClassName:"web.DHCEMSkinTest",
			MethodName:"UpdTestBatch",
			dataType:"text",
			"oeoriId":oeoreId,
			"skinSize":skinSize
		},function(retData){
			if(retData==0){
				$.messager.alert("提示","皮试批次保存成功！");
			}else{
				$.messager.alert("提示","皮试批次保存失败！");
			}
			return;
		});		
//		var skinNote="";
//		if(skinSize!=""){
//			var noteSkinSize ="批号:"+skinSize;
//			skinNote=skinNote==""?noteSkinSize:noteSkinSize+";"+skinNote;
//		}
//		
//		$cm({
//			ClassName:"web.DHCEMSkinTest",
//			MethodName:"UpdateOrderNote",
//			dataType:"text",
//			"oeoriId":oeoreId,
//			"skinNote":skinNote,
//			"skinSize":skinSize
//		},function(retData){
//			if(retData==0){
//				$.messager.alert("提示","皮试批次保存成功！");
//			}else{
//				$.messager.alert("提示","皮试批次保存失败！");
//			}
//			return;
//		});
	}	
}

// Creator: congyue
/// CreateDate: 2016-08-11
///  Descript: Ƥ��
var LINK_CSP="dhcapp.broker.csp";
var methodSel = [{ "id": "1", "text": $g("��ע��") }, { "id": "2", "text": $g("��Ĥ���鷨") },{ "id": "3", "text": $g("�㣨������") }, { "id": "4", "text": $g("�ں����鷨") },{ "id": "5", "text": "���۷�" },{ "id": "6", "text": "Ƥ�����鷨" }, { "id": "7", "text": $g("���۷�") }];
$(document).ready(function() {
	
	initSetPage(); ///ͨ��������ʾ����

	initPageValue();
	
	initMethod();
	
	if (Allgryflag==1){ //2016-10-27 ������ʾ�����ʾ
		$('#allergymess').show();
	}
  	
	//��ѡ�����
	InitUIStatus();
	
	 //Ƥ�Է���
	$('#TestMethodSel').combobox({
		valueField:'id',
		textField:'text',
		data:methodSel
	});  
		 	
	
	
    $('#skinTesttb').datagrid({
	    fit:true,
	    toolbar:[],//hxy 2023-01-05 st
	    title:$g('PPD��¼'),
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
			title: 'Ƥ��Ӳ��',
			align: 'center'
		}, {
			field: 'TestSkinVcl',
			title: '�ֲ�ˮ��',
			align: 'center'
		}, {
			field: 'TestSkinSwo',
			title: '����',
			align: 'center'
		}, {
			field: 'TestSkinNecrosis',
			title: '����',
			align: 'center'
		}, {
			field: 'TestSkinInflam',
			title: '�ܰ͹���',
			align: 'center'
		}, {
			field: 'TestSkinSing',
			title: '����',
			align: 'center'
		},{
			field: 'TestSkinSpora',
			title: 'ɢ��',
			align: 'center'
		}, {
			field: 'EpisodeID',
			title: '����id',
			align: 'center'
		}, {
			field: 'oeorid',
			title: 'ҽ��id',
			align: 'center'
		},{
			field: 'TestDate',
			title: '����',
			align: 'center'
		}, {
			field: 'TestTime',
			title: 'ʱ��',
			align: 'center'
		}, {
			field: 'TestUser',
			title: '��¼��',
			align: 'center'
		}, {
			field: 'id',
			title: 'id',
			align: 'center'
		}, {
			field: 'PDDResult',
			title: 'PPD���',
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
	
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
		});
	});
	
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
		});
	});
	
	//��Ƥ��ʱ�乴ѡʱ�����Ƥ��ʱ�������
	$HUI.radio("[name='ObserveTime']",{
        onChecked:function(e,value){
		   $('#ObserveDefine').val("");
        }
  	});
 	/*/��Ƥ��ʱ�乴ѡʱ�����Ƥ��ʱ�������
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
			ret = $g("��ǰƤ�Խ��")+":"+skinRsDesc+"  "+$g("Ƥ����")+":"+skinInfoArr[4]+"  "+$g("������")+":"+skinInfoArr[8];
			$("#skinRs").html(ret);
		}
	},"text",false);	
}


function opFormatter(value, rowData){
	return "<button class='btn btn-xs btn-danger btn-labeled fa fa-remove' type='button'  onclick='removeBTN(this);' data-Id='"+rowData.id+"'  >"+$g("ɾ��")+"</button>" 
}
function removeBTN(obj){
	id=$(obj).attr("data-Id");
	dhccBox.confirm("��ʾ","ȷ��Ҫɾ����?","",function(){
			runClassMethod(
				"web.DHCEMSkinTest", 
				"remove", 
				{'id':id}, 
				function(data){ //2016-10-26
				 	$('#skinTesttb').dhccQuery()   //Ĭ����ʾ��һҳ
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
	var TestAdmDr =adm,TestOeoriDr = oeoreId;//"420||2"; //����id  ҽ��id TestAdmDr = "455"  TestOeoriDr = "420||2"
	
	var TestMethod = $("#TestMethodSel").combobox("getText");
    var _data = $("#TestMethodSel").combobox('getData');/* ����������ѡ�� */
    var _b = false;/* ��ʶ�Ƿ��������б����ҵ����û�������ַ� */
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
        $.messager.alert("��ʾ","��ѡ��Ƥ�Է���");
        return;
    }
	
	data=serverCall("web.DHCEMSkinTest", "TestPayMoney", { 'oriOreId':TestOeoriDr})
	if (data!= "") {
			$.messager.alert("��ʾ",data)
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
		$.messager.alert("��ʾ","ʱ��Ϊ��")
		return;
	}
	var TestMethod = $("#TestMethodSel").combobox("getText");
	//var TestMethod=$("#TestMethodSel").dhccSelectM('data')[0].text;
	var parr = "TestAdmDr|" + TestAdmDr + "^TestStartDate|" + "^TestStartTime|" + "^RecUser|" + userId + "^TestOeoriDr|" + TestOeoriDr + "^ObserveTime|" + ObserveTime + "^TestLocDr|" + locId + "^TestMethod|" + TestMethod;
	runClassMethod( "web.DHCEMSkinTest", "Save", { 'id':'','parr':parr,'typ':'count'}, function(data){
		if (data != "0") {
			$.messager.alert("��ʾ",data);
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
			
			$.messager.alert("��ʾ","��ʱ�ɹ�!","info",function(){
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
	//����ʱ��
	var ObserveDefine=$('#ObserveDefine').val();
	if (ObserveTime=="0"){retTime = "10����";maxtime=10*60;}
	if (ObserveTime=="1"){retTime = "15����";maxtime=15*60;}
	if (ObserveTime=="2"){retTime = "20����";maxtime=20*60;}
	if (ObserveTime=="3"){retTime = "48Сʱ";maxtime=48*60*60;}
	if (ObserveTime=="4"){retTime = "72Сʱ";maxtime=72*60*60;}
	if (ObserveTime=="5"){retTime = "30����";maxtime=30*60;}
	if ((ObserveDefine>0)&&(isNaN(ObserveDefine)==false)){retTime = ObserveDefine+ "����";maxtime=ObserveDefine*60;}
	return retTime;
}
function butUpdateFn() {

	var count = 0,oeoriStr = oeoreId;//"420||2";
	var TestAdmDr =adm,TestOeoriDr = oeoreId;//"420||2"; //����id  ҽ��id TestAdmDr = "455"  TestOeoriDr = "420||2"
	if (TestOeoriDr != "") {
		var tmpTestOeoriDr = TestOeoriDr.split("||");
		TestOeoriDr = tmpTestOeoriDr[0] + "!!" + tmpTestOeoriDr[1];
	}

	data=serverCall("web.DHCEMSkinTest", "IfPatPSEnd", { 'Adm':TestAdmDr,'oeoriId':oeoriStr})
	 if (data == "1") {
			$.messager.alert("��ʾ","ʱ��δ��������Ƥ�Խ��")
			return;
	}

	var skinTest = "",
		skinNote = "";
	//Ƥ�Խ����Y ����  N ����
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
			$.messager.alert("��ʾ","��ѡ��Ƥ�Խ��");
			return;
	} 

	//ȡPPD������
    //Ƥ��Ӳ�� ��С
    var AbnormalNoteText1=$('#AbnormalNoteText1').val(); 
    var AbnormalNoteText2=$('#AbnormalNoteText2').val(); 
	if ((AbnormalNoteText1!= "") || (AbnormalNoteText2!= "")) {
		var skinNote ="Ƥ��Ӳ��"; //objcAbnormalNote.innerText;
		if (AbnormalNoteText1!= "") skinNote = skinNote + " " + AbnormalNoteText1 + "mm";
		if (AbnormalNoteText2 != "") skinNote = skinNote + "*" + AbnormalNoteText2 + "mm";
		if (skinNote != "") skinNote = skinNote + ";";
	}

    //�ֲ�ˮ�� ��С
    var AbnormalNote1Text1=$('#AbnormalNote1Text1').val(); 
    var AbnormalNote1Text2=$('#AbnormalNote1Text2').val(); 
	if ((AbnormalNote1Text1!= "") || (AbnormalNote1Text2!= "")) {
		var skinNote = skinNote + " " +"�ֲ�ˮ��";//+ " " + objcAbnormalNote1.innerText;
		if (AbnormalNote1Text1!= "") skinNote = skinNote + " " + AbnormalNote1Text1 + "mm";
		if (AbnormalNote1Text2!= "") skinNote = skinNote + "*" + AbnormalNote1Text2 + "mm";
		//ˮ�ݷֲ�  0 ����   1  ɢ��    
		var AbnormalNote ="";
	    $("input[name=AbnormalNote]").each(function(){
			if($(this).is(':checked')){
				AbnormalNote =this.value;
			}
		})
		var AbnormalNotetext=""
		if (AbnormalNote==0){
			AbnormalNotetext="����";
			skinNote = skinNote + " " + AbnormalNotetext;
		}
		if (AbnormalNote==1){
			AbnormalNotetext="ɢ��";
			skinNote = skinNote + " " + AbnormalNotetext;
		}
		if (skinNote != "") skinNote = skinNote + ";";
	}

    //����   0 ����   1  �ܰ͹���    
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
		AbnormalNote2text="����"; //����
		skinNote = skinNote + " " + AbnormalNote2text; 
		if (skinNote != "") skinNote = skinNote + ";";
	}
	if (AbnormalNote3==11){
		AbnormalNote3text="�ܰ͹���"; //�ܰ͹���
		skinNote = skinNote + " " + AbnormalNote3text;
		if (skinNote != "") skinNote = skinNote + ";";
	}

    //���� ��С
    var AbnormalNote4Text1=$('#AbnormalNote4Text1').val(); 
    var AbnormalNote4Text2=$('#AbnormalNote4Text2').val(); 
	if ((AbnormalNote4Text1!= "") || (AbnormalNote4Text2!= "")) {
		var skinNote = skinNote + " " + "����";//+ " " + objcAbnormalNote4.innerText;
		if (AbnormalNote4Text1!= "") skinNote = skinNote + " " + AbnormalNote4Text1 + "mm";
		if (AbnormalNote4Text2!= "") skinNote = skinNote + "*" + AbnormalNote4Text2+ "mm";
		if (skinNote != "") skinNote = skinNote + ";";
	}

	var TestResult = "";
	if (skinTest == "Y") TestResult = "(+)";
	if (skinTest == "N") TestResult = "(-)";
	//PPD�������ж�/�Զ���Ƥ��������
	
	if (IfPPDOrder == 1) {
		if (skinNote != "") {
			TestResult = $("#PPDResult").val() //GetPPDStandard(skinNote, AbnormalNoteText1);
			if (TestResult == "(-)") {skinTest = "N"}
			else {skinTest = "Y"};
		} else {
			$.messager.alert("��ʾ","��ѡ��PPD������");
			return;
		}
	}

	data=serverCall("web.DHCEMSkinTest", "IfPatPSEnd", { 'Adm':TestAdmDr,'oeoriId':oeoriStr})
	if (Number(data)==1) {
			$.messager.alert("��ʾ","ʱ��δ��������Ƥ�Խ��")
			return;
	}

	//Ƥ���û�
	var userCode =$('#userCode').val();
	var passWord = $('#passWord').val();
	//�����û�
	var userCodeAudit = $('#userCodeAudit').val();
	var passWordAudit = $('#passWordAudit').val();
	
	var skinUserID ="",skinUserCode="";    ///����Ҫǩ����ȡ��ǰ��¼����
	var skinAuditUserID ="",skinAuditUserCode="";
	if(SKINNEEDSIGN==1){   ///Ϊ1��ʾ��Ҫǩ��
		if (userCode == "") {
			$.messager.alert("��ʾ","������Ƥ���û�");
			return;
		}
		if (passWord == "") {
			$.messager.alert("��ʾ","������Ƥ���û�����");
			return;
		}
		if((SKINSIGNNUM==2)){
			if (userCodeAudit == "") {
				$.messager.alert("��ʾ","�����븴���û�");
				return;
			}
			if (passWordAudit == ""){
				$.messager.alert("��ʾ","�����븴���û�����");
				return;
			}
			if(SKINSINGTWOUSER!=1){
				if(userCode.toUpperCase()==userCodeAudit.toUpperCase()){
					$.messager.alert("��ʾ","Ƥ���û��͸����û�������Ϊͬһ��");
					return;
				}	
			}
		}
		data=serverCall("web.DHCEMSkinTest", "ConfirmPassWord", { 'userCode':userCode,'passWord':passWord,'LocId':LgCtLocID})
		if (data.split("^")[0] != 0) {
			$.messager.alert("��ʾ","Ƥ���û�:" + data);
			return;
		} else {
			skinUserID = data.split("^")[1];   ///��������û�ID
			skinUserCode=userCode;
		}
		if(SKINSIGNNUM==2){
			data=serverCall("web.DHCEMSkinTest", "ConfirmPassWord", { 'userCode':userCodeAudit,'passWord':passWordAudit,'LocId':LgCtLocID})
			if (data.split("^")[0] != 0) {
				$.messager.alert("��ʾ","�����û�:" + data);
				return;
			}else{
				skinAuditUserID = data.split("^")[1];   ///�����������û�ID
				skinAuditUserCode=userCodeAudit;
			}
		}else{
			skinAuditUserID=LgUserID;
			skinAuditUserCode=LgUserCode;
		}
	}else{
		skinUserID = LgUserID;   ///��������û�ID
		skinUserCode=LgUserCode;
		skinAuditUserID=LgUserID;
		skinAuditUserCode=LgUserCode;
	}
	
	
	///Ƥ������
	var skinSize = $('#skinSize').val();
	if((ISSHOWATTACH==2)&&(skinSize=="")){
		$.messager.alert("��ʾ","����дƤ������");
		return;
	}
	if(skinSize!=""){
		skinSize =$g("����")+":"+skinSize;
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
	
	//��Ƥ�Խ��
	var retStr ="";
	retStr=serverCall( "web.DHCEMSkinTest","SetSkinTestResultXH",parObj);
	
	if (retStr == "0") {
		$.messager.alert("��ʾ","�����ɹ���","info",function(){
			window.close()
		});
		
		if(parent.top.frames[0]!==undefined){
			parent.top.frames[0].searchPatTest();
			parent.top.frames[0].refreshAllergy(oeoriStr);
			parent.top.frames[0].frames[0].search();
			parent.top.frames[0].websys_showModal("close");
		}
		
	 } else {
		$.messager.alert("��ʾ",retStr);
		return;
	} 

}

function getPDDDataInfo() {
	var userId = LgUserID;
	var oeoriStr = oeoreId;//"420||2";
	var TestAdmDr =adm,TestOeoriDr = oeoreId;//"420||2"; //����id  ҽ��id TestAdmDr = "455"  TestOeoriDr = "420||2"
	if (TestOeoriDr != "") {
		var tmpTestOeoriDr = TestOeoriDr.split("||");
		TestOeoriDr = tmpTestOeoriDr[0] + "!!" + tmpTestOeoriDr[1];
	}
	// w ##class(web.DHCEMSkinTest).GetIfPPDOrder("343||15||1")
    //Ƥ��Ӳ�� ��С
    var TestSkinSityOne=$('#AbnormalNoteText1').val(); 
    var TestSkinSityTwo=$('#AbnormalNoteText2').val(); 
    //�ֲ�ˮ�� ��С
    var TestSkinVclOne=$('#AbnormalNote1Text1').val(); 
    var TestSkinVclTwo=$('#AbnormalNote1Text2').val(); 
	//ˮ�ݷֲ�  0 ����   1  ɢ��    
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
	
    //����   0 ����   1  �ܰ͹���    
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
		TestSkinNecrosis="1"; //����
	}
	if (AbnormalNote3==11){
		TestSkinInflam="1"; //�ܰ͹���
	}
    //���� ��С
    var TestSkinSwoOne=$('#AbnormalNote4Text1').val(); 
    var TestSkinSwoTwo=$('#AbnormalNote4Text2').val(); 
	var PPDResult=$("#PPDResult").val();
	//if ((TestSkinSityOne == "") && (TestSkinVclOne == "") && (TestSkinSwoOne == "") && (TestSkinNecrosis == "") && (TestSkinInflam == "") && (TestSkinSing == "") && (TestSkinSpora == "")) return;
	var parr = "TestAdmDr|" + TestAdmDr + "^TestDate|" + "^TestTime|" + "^RecUser|" + userId + "^TestOeoriDr|" + TestOeoriDr + "^TestSkinSityOne|" + TestSkinSityOne + "^TestSkinSityTwo|" + TestSkinSityTwo + "^TestSkinVclOne|" + TestSkinVclOne + "^TestSkinVclTwo|" + TestSkinVclTwo + "^TestSkinSwoOne|" + TestSkinSwoOne + "^TestSkinSwoTwo|" + TestSkinSwoTwo + "^TestSkinNecrosis|" + TestSkinNecrosis + "^TestSkinInflam|" + TestSkinInflam + "^TestSkinSing|" + TestSkinSing + "^TestSkinSpora|" + TestSkinSpora+ "^PPDResult|" + PPDResult;;
	
	return parr;
}
/// PPDƤ�Խ���ж���׼
function GetPPDStandard(AbnormalNote, AbnormalNoteText1) {
	var retStr = "";
	if (AbnormalNote.indexOf("Ƥ��Ӳ��") > -1) {
		AbnormalNoteText1 = eval(AbnormalNoteText1);
		if (AbnormalNoteText1 < 5) retStr = "(-)";
		if ((AbnormalNoteText1 >= 5) && (AbnormalNoteText1 < 10)) retStr = "(+)";
		if ((AbnormalNoteText1 >= 10) && (AbnormalNoteText1 < 20)) retStr = "(++)";
		if (AbnormalNoteText1 >= 20) retStr = "(+++)";
	}
	if ((AbnormalNote.indexOf("�ֲ�ˮ��") > -1) || (AbnormalNote.indexOf("����") > -1) || (AbnormalNote.indexOf("�ܰ͹���") > -1)) {
		retStr = "(++++)";
	}
	return retStr;
}

//��ɾ���
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
	var _content = "��ɾ���"
	$.messager.model = { 
	    ok:{ text: "��", classed: 'btn-default' },
	    cancel: { text: "��", classed: 'btn-error' }
	};
	$.messager.confirm("��ʾ", "�Ƿ���ɾ���?", function() { 
	    $.messager.$.messager.alert("��ʾ","��ɾ�����!");
	});
}*/
function getPPD(){

	try{
		retStr="";

		value=$('#AbnormalNoteText1').val();
		//Ƥ��Ӳ��
		if($.trim(value)!=""){
			if (value < 5) retStr = "(-)";
			if ((value >= 5) && (value < 10)) retStr = "(+)";
			if ((value >= 10) && (value < 20)) retStr = "(++)";
			if (value >= 20) retStr = "(+++)";
		}
		value=$('#AbnormalNoteText2').val();
		//Ƥ��Ӳ��
		if($.trim(value)!=""){
			if (value < 5) retStr = "(-)";
			if ((value >= 5) && (value < 10)) retStr = "(+)";
			if ((value >= 10) && (value < 20)) retStr = "(++)";
			if (value >= 20) retStr = "(+++)";
		}
		
		if(($("#AN0").is(':checked'))||($("#AN1").is(':checked'))||($("#AN10").is(':checked'))||($("#AN11").is(':checked'))){
			retStr = "(++++)";
		}
		//�ֲ�ˮ�� AbnormalNote1Text
		value=$('#AbnormalNote1Text1').val();
		if(($.trim(value)!="")&&($.trim(value)!=0)){
				retStr = "(++++)";
		}
		value=$('#AbnormalNote1Text2').val();
		if(($.trim(value)!="")&&($.trim(value)!=0)){
				retStr = "(++++)";
		}
		//���� AbnormalNote4Text
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
		$("#userCode").val($g("����ǩ��"));
		$("#passWord").val($g("����ǩ��"));
		$("#userCodeAudit").val($g("����ǩ��"));
		$("#passWordAudit").val($g("����ǩ��"));
	}else{
		$('#userCode').val(LgUserCode);	
	}
	if(SKINSIGNNUM!=2){
		$("#userCodeAudit").attr("disabled",true);
		$("#passWordAudit").attr("disabled",true);
		$("#userCodeAudit").val($g("���踴��"));
		$("#passWordAudit").val($g("���踴��"));

	}
	$.m({ClassName:"web.DHCEMSkinTest",MethodName:"GetOrderInfo",OrdItmID:oeoreId},function(retData){
		if (retData!=""){
			retDataArr=retData.split("^");
			$("#arciDesc").html($g("��ǰҽ������")+"��"+retDataArr[0]);
			var skinRs=retDataArr[1];
			if(skinRs!=""){
				$HUI.linkbutton("#btnStartSkinTest").disable();
				$("#btnStartSkinTest").attr("title","�Ѿ������,�������ٴμ�ʱ!");
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
			$("#skinSize").val(SkinSize.replaceAll("����:",""));
		}
	});
	
	
	return;
}




function skinSizePress(e){
	if(e.keyCode==13){
		///Ƥ������
		var skinSize = $('#skinSize').val();
		skinSize =$g("����")+":"+skinSize;
		//if((ISSHOWATTACH==1)&&(SKINNEEDPCMUST==1)&&(skinSize=="")){
		if(((ISSHOWATTACH==1)||(ISSHOWATTACH==2))&&(skinSize=="")){
			$.messager.alert("��ʾ","Ƥ�����β���Ϊ�գ�");
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
				$.messager.alert("��ʾ","Ƥ�����α���ɹ���");
			}else{
				$.messager.alert("��ʾ","Ƥ�����α���ʧ�ܣ�");
			}
			return;
		});		
//		var skinNote="";
//		if(skinSize!=""){
//			var noteSkinSize ="����:"+skinSize;
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
//				$.messager.alert("��ʾ","Ƥ�����α���ɹ���");
//			}else{
//				$.messager.alert("��ʾ","Ƥ�����α���ʧ�ܣ�");
//			}
//			return;
//		});
	}	
}

/// Description: ��������׷�ټ�¼��  
/// Creator: congyue
/// CreateDate: 2020-01-10
var EvaRecordId="",LinkRecordId="",WinCode="",AuditList="",CancelAuditList="",StaFistAuditUser="",StsusGrant="",RepStaus="";
var userName="";
var AssessFlag="",LocHeadNurEvaFlag="",NurDepEvaFlag=""; ///���۰�ť��ʶ���ƻ�ʿ�����۰�ť��ʶ���������۰�ť��ʶ
var EvaFlagList=""; /// ���۱�ʶ��  ���۰�ť��ʶ^�ƻ�ʿ�����۰�ť��ʶ^�������۰�ť��ʶ 
$(document).ready(function(){
	EvaRecordId=getParam("recordId");  //������id
	LinkRecordId=getParam("LinkRecordId");  //��������¼ID
	AuditList=getParam("AuditList");  //��˴�
	CancelAuditList=getParam("CancelAuditList");  //������˴�
	StaFistAuditUser=getParam("StaFistAuditUser");  //��һ������
	StsusGrant=getParam("StsusGrant");  //��˱�ʶ
	RepStaus=getParam("RepStaus");  //����״̬
	WinCode=getParam("code");  //��������¼code
	EvaFlagList=getParam("EvaFlagList");  //���۱�ʶ��
	reportControl();			// ������  	
	InitButton();				// ��ʼ����ť
	CheckTimeornum();  //ʱ��У��
	InitCheckRadio();//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
});

// ������
function reportControl(){
	$("#left-nav").hide();
	$("#anchor").hide();
	$("#gotop").hide();
	$("#gologin").hide();
	$("#footer").hide();
	$("#assefooter").show();
	$("#from").css({
		"margin-left":"20px",
		"margin-right":"20px"
	});
	$('#AuditMessage').hide(); //2018-06-12 cy ������Ϣ����
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
			setManImprove()
		});
	})
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
			setManImprove()
		});
	});
	// �������ڿ���
	chkdate("MeetDate","MeetTime");
	add_event();
	var Caserow=0
	var CaseList=$('#CaseImprovement').val().split("\n")
	var Caselen=CaseList.length;
	for(i=0;i<Caselen;i++){
		Caserow=Caserow+parseInt(CaseList[i].length/50)+1;
	}
	var Caseheightlen=(Caserow)*18;
	if($('#CaseImprovement').val()!=""){
		$("#CaseImprovement").css({
			"height":Caseheightlen
		});
	}
	//�λ���Ա 
	$('#Participants').css({
		"width":800,
		"max-width":800
	});
	RepSetRead("Participants","input",1);	
	//����
	$('#ManaImprovement-94378-94951').css({
		"width":300,
		"max-width":300
	});
	//�����Ľ����ɱ༭
	$("#CaseImprovement").attr("readonly",'readonly');
	$("body").click(function(){
		AllStyle("textarea","",100);
  		InitLabInputText(".lable-input");
		$(".mytext").bind('input propertychange ',function(){
	    	setManImprove();
	 	});
	 	$(".mytext").blur('input propertychange ',function(){
	    	setManImprove();
	 	});
	})
	 setTimeout(function(){ //��ʱ���body
        $("body").click();
    },500)	
	$(".lable-input").css('width','100px');
	$(".lable-input").css('max-width','100px');
	var EvaData=EvaFlagList.replace(/(^\s*)|(\s*$)/g,"").split("^");
	AssessFlag=EvaData[0];
	LocHeadNurEvaFlag=EvaData[1];
	NurDepEvaFlag=EvaData[2];
	if(EvaRecordId!=""){ 
		// ��Ӱ�ť���� 
		$('#ParPantsAddBut').hide();
		//���Ҳ����¼����� ���ɱ༭
		$("#HeadNurCauseAnalysis-panel input").attr("readonly",'readonly');
		$("#HeadNurCauseAnalysis-panel textarea").attr("readonly",'readonly');
		$("#MeetDate").datebox({"disabled":true});
		$("#HeadNurCauseAnalysis-panel input[type=checkbox]").attr("disabled",true); 
		//���Ĵ�ʩ ���ɱ༭
		$("#Recmeasure-panel input").attr("readonly",'readonly');
		$("#CaseImprovement").attr("readonly",'readonly');
		$("#Recmeasure-panel textarea").attr("readonly",'readonly');
		$("#Recmeasure-panel input[type=checkbox]").attr("disabled",true); 
		//�ֳ���������׷�ټ�¼  ���ɱ༭
		$("[id^='HeadNurEvaluate-94387-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value!="")){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains('+$g("ɾ��")+')').parent().hide();
			}
			if(AssessFlag!="Y"){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains('+$g("����")+')').parent().hide();
			}
		})	
	}

}
//��ť�����뷽����
function InitButton(){
	$("#AsseSaveBut").on("click",function(){
		SaveAsse(0);
	})
	//�λ���Ա ��Ӱ�ť�¼�
	$('#ParPantsAddBut').on("click",function(){
		StaffEnter();
	})
	$('#Find').bind("click",QueryName);   //�����ѯ
   	$('#Add').bind("click",MemAdd);     //�����ӣ�����ѡ����Ա��ӵ������ �λ���Ա
}

function setManImprove()
{
    var list="",PersonFactorCom="",DiviceFactorCom="",GoodsFactorCom="",ManaFactorCom="",EnvirFactorCom="",OthFactorCom="";
    var i=0,j=0,k=0,l=0,h=0,m=0;
    var PersonFactorComlist="",DiviceFactorComlist="",GoodsFactorComlist="",ManaFactorComlist="",EnvirFactorComlist="",OthFactorComlist=""; 
	$("input[id^='PersonFactorCom']").each(function(){  
		if($(this).is(':checked')){                
			if(this.id.indexOf("PersonFactorCom-99762")>=0){ // ���߼�����	
				i=i+1;
				PersonFactorCom=i+"��"+$g("���߼�����")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorComlist=PersonFactorComlist+PersonFactorCom;
			}
			if(this.id.indexOf("PersonFactorCom-99763")>=0){     //��ʿ
				i=i+1;	
				PersonFactorCom=i+"��"+$g("��ʿ")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorComlist=PersonFactorComlist+PersonFactorCom;
			} 
			if(this.id.indexOf("PersonFactorCom-99764")>=0){ //ҽ������	
				i=i+1;
				PersonFactorCom=i+"��"+$g("ҽ������")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorComlist=PersonFactorComlist+PersonFactorCom
			}
		}
	});
	if(PersonFactorComlist!=""){
		list=list+"\n"+$g("�ˣ���Ա����")+"\n"+PersonFactorComlist;
	}

	$("input[id^='DiviceFactorCom']").each(function(){
		if($(this).is(':checked')){
			j=j+1;
			DiviceFactorCom=j+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			DiviceFactorComlist=DiviceFactorComlist+DiviceFactorCom;
		}
	});	
	if(DiviceFactorComlist!=""){
		list=list+"\n"+$g("�����豸����")+"\n"+DiviceFactorComlist;
	}
		
	$("input[id^='GoodsFactorCom']").each(function(){
		if($(this).is(':checked')){
			k=k+1;
			GoodsFactorCom=k+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			GoodsFactorComlist=GoodsFactorComlist+GoodsFactorCom;
		}
	});
	if(GoodsFactorComlist!=""){
		list=list+"\n"+$g("���Ʒ����")+"\n"+GoodsFactorComlist;
	}
	
	$("input[id^='ManaFactorCom']").each(function(){
		if($(this).is(':checked')){
			l=l+1;
			ManaFactorCom=l+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			ManaFactorComlist=ManaFactorComlist+ManaFactorCom;
		}
	});
	if(ManaFactorComlist!=""){
		list=list+"\n"+$g("�������������ߡ���������")+"\n"+ManaFactorComlist;
	}
	
	$("input[id^='EnvirFactorCom']").each(function(){
		if($(this).is(':checked')){
			h=h+1;
			EnvirFactorCom=h+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			EnvirFactorComlist=EnvirFactorComlist+EnvirFactorCom;
		}
	});
	if(EnvirFactorComlist!=""){
		list=list+"\n"+$g("������������")+"\n"+EnvirFactorComlist;
	}
	
	$("input[id^='OthFactorCom']").each(function(){
		if($(this).is(':checked')){
			m=m+1;
			OthFactorCom=m+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			OthFactorComlist=OthFactorComlist+OthFactorCom;
		}
	});
	if(OthFactorComlist!=""){
		list=list+"\n"+$g("��������������")+"\n"+OthFactorComlist;
	}
	var Caserow=0
	var CaseList=list.split("\n")
	var Caselen=CaseList.length;
	for(i=0;i<Caselen;i++){
		Caserow=Caserow+parseInt(CaseList[i].length/50)+1;
	}
	var Caseheightlen=(Caserow)*18;
	$("#CaseImprovement").css({
		"height":Caseheightlen
	});
	$('#CaseImprovement').val(list)
	
}
//�������۱���
function SaveAsse(flag)
{
	///����ǰ,��ҳ���������м��
	if(!(checkRequired()&&checkother())){
		return;
	}
	runClassMethod("web.DHCADVFormRecord","SaveRecord",
		{'user':LgUserID,
		 'formId':$("#formId").val(),
		 'formVersion':$("#formVersion").val(),
		 'par':loopStr("#from"),
		 'recordId':EvaRecordId,
		 'linkRecordId':LinkRecordId
		 },
		function(datalist){ 
			var data=datalist.replace(/(^\s*)|(\s*$)/g,"").split("^");
			EvaRecordId=data[1]
			if (data[0]=="0") {
				window.parent.closeRepWindow();
				window.parent.location.reload();// 2018-11-20 cy ���汨���ˢ�¸�����
				if(flag==1){
					window.parent.SetRepInfo(data[1],WinCode);
					window.parent.parent.CloseWinUpdate();
					window.parent.parent.Query();
				}
			}else{
				return;
			}
		},"text")
	
}
//У��
function checkother(){
	
	//����Ľ�  ManaImprovement-94378-96091
	var ManaImprovementoth=0;
	$("input[type=checkbox][id^='ManaImprovement']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.96082'][class='lable-input']").val()=="")){
				ManaImprovementoth=-1;
			}
			if((this.value==$g("�ƶȡ����̼��淶�ƶ����޶�"))){
				if(!($("#ManaImprovement-94378-94949").is(':checked'))&&!($("#ManaImprovement-94378-94950").is(':checked'))){
					ManaImprovementoth=-2;
				}
				if($("input[id='ManaImprovement-94378-94951']").val()==""){
					ManaImprovementoth=-2;
				}
			}
		}	
	})
	if(ManaImprovementoth==-2){
		$.messager.alert($g("��ʾ:"),"��"+$g("����Ľ�")+"��"+$g("��ѡ")+$g('�ƶȡ����̼��淶�ƶ����޶�')+"��"+$g("�빴ѡ����д����")+"��");	
		return false;
	}
	if(ManaImprovementoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("����Ľ�")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	return true;
}
//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	
	//����Ľ�  �ƶȡ����̼��淶�ƶ����޶�  ����  ��д�����Զ���ѡ�ƶȡ����̼��淶�ƶ����޶���ȡ����ѡʱ������Ϊ��
	if($("input[type=checkbox][id='ManaImprovement-94378']").is(':checked')){
		if($("#ManaImprovement-94378-94951").val()==""){
			$("#ManaImprovement-94378-94951").attr("readonly",false);
		}
	}else{
		$("#ManaImprovement-94378-94951").val("");
		$("input[type=radio][id^='ManaImprovement-94378-']").removeAttr("checked");
	}
	$("#ManaImprovement-94378-94951").bind("blur",function(){
		if($("#ManaImprovement-94378-94951").val()!=""){
			$("input[type=checkbox][id='ManaImprovement-94378']").prop("checked",true) ;
		}
	})
	if($("input[type=radio][id^='ManaImprovement-94378-']").is(':checked')){
		$("input[type=checkbox][id='ManaImprovement-94378']").prop("checked",true) ;
	}
	
	
}

function add_event(){
	AllStyle("textarea","",100);
	chkTableDate("HeadNurEvaluate-94387-94393-94398");
	//����ʱ�����
	/*$("input[id^='HeadNurEvaluate-94387-94393-94398']").each(function(){
		if((this.id.split("-").length==4)){
			var datevalue=$("input[id^='"+this.id+"']").datebox("getValue");
			$("input[id='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
				}
			});
			$("input[id^='"+this.id+"']").datebox("setValue",datevalue);
		}
	}) */
	
}

//ȷ������  2018-04-24
function FormConfirmAudit()
{	
	if(!(checkRequired()&&checkother())){
		return;
	} 
	runClassMethod("web.DHCADVCOMMONPART","AuditMataReport",{'params':AuditList},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert("��ʾ:","��˴���,����ԭ��:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"��"+errnum+"������"
			return;
		}
		if(jsonString.ErrCode == 0){
			SaveAsse(1);
		}
	},"json",false);
	
}
//�������� 2018-04-24
function FormCancelAuditBt()
{	
	if ((StaFistAuditUser!="")&(StaFistAuditUser!=LgUserName)){
		$.messager.alert("��ʾ:","����Ϊ���ر��棬��δ���ظ���ǰ��¼�ˣ���Ȩ�޳�����ˣ�");
		return;
	}
	//��������
	runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':CancelAuditList},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert("��ʾ:","������˴���,����ԭ��:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"��"+errnum+"������"
			return;
		}
		if(jsonString.ErrCode == 0){
			SaveAsse(1);
		}
	},"json",false);
		
}
//ʱ�� ����У��
function CheckTimeornum(){
	//ʱ������У��
	//����ʱ��  sufan 2019-06-18 ��ͳһȥ�����Ჿ��
	/*chktime("MornRepMeetTime");*/
	//����ʱ��
	chktime("MeetTime","MeetDate");
	
	chkTableDate("LocHeadNurEvaluate"); //hxy 2020-03-19 st
	$("a[onclick*='addRow']").click(function(){
		chkTableDate("LocHeadNurEvaluate");
	}); //ed	
	
}
//��Ա�س��¼����ش���
function StaffEnter()
{
	$('#staffwin').show();
	$('#staffwin').window({
		title:$g('������Ա��Ϣ'),
		collapsible:false, //true, //hxy 2020-03-18 st
		minimizable:false,
		maximizable:false, //ed
		border:false,
		closed:"true",
		modal:true,
		width:500,
		height:400
	}); 
	/*var scrollTop=$('body').scrollTop(); //hxy 2020-03-22 chrome st
	$("body").css("height",scrollTop);
	$('#staffwin').panel('resize',{ 
		top:scrollTop+((screen.availHeight-400)/4)
	}); //ed
	*/
    $('#staffwin').window('open');
    $("#UserNames").val("");
    $('#MonAdd').hide();// ��ӳ�����Ա��ť����
    InitStaffGrid() ;      
}

//��ʼ��������Ա�б�
function InitStaffGrid()
{
	//����columns
	var columns=[[
	     {field:"ck",checkbox:'true',width:40},
		 {field:'userCode',title:$g('�û�Code'),width:100},
		 {field:'userName',title:$g('�û�����'),width:100}
		]];
	
	//����datagrid
	$('#user').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetStaff&Input='+LgCtLocID,
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:200,  // ÿҳ��ʾ�ļ�¼����
		pageList:[200,400],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		selectOnCheck:true,
		onUnselect:function(rowIndex, rowData)
		{
			userName=$("#UserNames").val();
			var name =rowData.userName
             if(userName.indexOf(name) != -1)
             {
	             userName=userName.replace(name+"��","")
	             $("#UserNames").val(userName);
             }
		},
		 onSelect:function(rowIndex, rowData)
		 {
	       var userName = rowData.userName
	       MeetMember(userName)
		 },onLoadSuccess:function(data){  
			if(userName!=""){
				for(var i=0;i<data.rows.length;i++){
					var Name = data.rows[i].userName+"��";
					if(userName.indexOf(Name)>=0){
						$("#user").datagrid("selectRow",i);
					}
				}
			}
		}
	});	
	$("#UserNames").val($("#Participants").val()); /// ����������Ա����������Ա��ֵ(���Ĳλ���Ա)
	$(".datagrid-header-check input[type=checkbox]").on("click",function(){ ///2018-04-13 cy ���۽���
		AllMember();
	})
}
function AllMember(){
	var rows = $("#user").datagrid('getSelections');
	if(rows.length==0){
		$("#UserNames").val("");
	}
	var userNames="";
	for(var i=0;i<rows.length;i++){
		if(userNames==""){
			userNames=rows[i].userName+"��";
		}else{
			userNames=userNames+rows[i].userName+"��";
		}
		
	}
	$("#UserNames").val(userNames);
	//MeetMember(userNames) ;
}
//��ѯ
function QueryName()
{
	//1�����datagrid 
	$('#user').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var UserName=$("#UserName").val();
	var params=UserName+"^"+LgCtLocID;
	$('#user').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetStaff',
		queryParams:{
		Input:params}	
	});
}

//��ӵ��λ���Ա
function MemAdd()
{
  userName=$("#UserNames").val()
  $("#Participants").val(userName)	
  $('#staffwin').window('close');
}
//��ӵ�������Ա
function MonAdd()
{
  userName=$("#UserNames").val()
  $("#MornRepMeetpants").val(userName)	
  $('#staffwin').window('close');
}
//ѡ��λ���Ա
function MeetMember(name)
{
	if(name==""){
	  $("#UserNames").val("");
	}
	userName=$("#UserNames").val();
    if(userName.indexOf(name) != -1){
	    return true;  
    }
	if(userName==""){
	  userName=name+"��";
	}else{
	  userName=userName+name+"��";
	}
	$("#UserNames").val(userName);		
}
///���������¼�����ԭ�������ѡ��������д�ĸĽ���ʩ   ���inputֵΪ�Ľ���ʩ��  �򷵻�""
function getInputValue(id){
	var inputvalue=getHideInputValue(id);
	if(inputvalue=="��"){
		inputvalue="";
	}
	if((inputvalue!="��")&&(inputvalue!="")){
		inputvalue=$g("���Ĵ�ʩ��")+inputvalue;
	}
	return inputvalue;
	
}

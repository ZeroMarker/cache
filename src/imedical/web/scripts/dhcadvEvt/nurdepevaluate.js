/// Description: �������۵����۽��� 
/// Creator: congyue
/// CreateDate: 2018-04-16
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
//��ȡ������Ϣ
function InitPatInfo(){};
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
	$('#AuditMessage').hide(); //2018-06-12 cy ������Ϣչ��
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	// �������ڿ���
	chkdate("NurDepMeetDate","NurDepMeetTime");
	add_event();
	var EvaData=EvaFlagList.replace(/(^\s*)|(\s*$)/g,"").split("^");
	AssessFlag=EvaData[0];
	LocHeadNurEvaFlag=EvaData[1];
	NurDepEvaFlag=EvaData[2];
	if(EvaRecordId!="")	{
		// ��Ӱ�ť���� 
		$('#ParPantsAddBut').hide();
		//�����������¼����� ���ɱ༭
		$("#NurDepCauseAnalysis-panel input").attr("readonly",'readonly');
		$("#NurDepCauseAnalysis-panel textarea").attr("readonly",'readonly');
		$("#NurDepMeetDate").datebox({"disabled":true});
		$("#NurDepCauseAnalysis-panel input[type=radio]").attr("disabled",true);  
		$("#NurDepCauseAnalysis-panel input[type=checkbox]").attr("disabled",true);  
		//�¼������뿼�� ���ɱ༭
		$("#NurDepAdvice").attr("readonly",'readonly');
		$("#RepQualita-panel input[type=radio]").attr("disabled",true);  
		
		//����׷�ټ�¼  ���ɱ༭
		$("[id^='NurDepRecord-94470-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value!="")){
				$("[id^='"+rowid+"'][id$='."+rownum+"']").attr("readonly",'readonly');
				if(this.type=="text"){
					$("[id^='"+rowid+"'][id$='."+rownum+"']").datebox({"disabled":true});
				}
				if((this.type=="radio")&&(this.checked==true)){
					
					$("input[type=radio][id^='NurDepRecord-94470-94477-'][id$='."+rownum+"']").attr("disabled",true);
				}
				$('a:contains('+$g("ɾ��")+')').parent().hide();
			}
			if(NurDepEvaFlag!="1"){
				$("[id^='"+rowid+"'][id$='."+rownum+"']").attr("readonly",'readonly');
				if(this.type=="text"){
					$("[id^='"+rowid+"'][id$='."+rownum+"']").datebox({"disabled":true});
				}
				if((this.type=="radio")&&(this.checked==true)){
					
					$("input[type=radio][id^='NurDepRecord-94470-94477-'][id$='."+rownum+"']").attr("disabled",true);
				}
				$('a:contains('+$g("����")+')').parent().hide();
			}
			
			
		})
	}
	//�λ���Ա 
	$('#NurDepParticipants').css({
		"width":800,
		"max-width":800
	});
	RepSetRead("NurDepParticipants","input",1);	
	$("body").click(function(){ 
		AllStyle("textarea","",100);
  		InitLabInputText(".lable-input");
	})
	setTimeout(function(){ //��ʱ���body
        $("body").click();
    },500)	
	$(".lable-input").css('width','100px');
	$(".lable-input").css('max-width','100px');
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
  	$('#MonAdd').hide();  //���� ��ӳ�����Ա��ť
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
				window.parent.CloseAsseWin();
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
//�����湴ѡ�������Ƿ���д�����
function checkother(){
	//����ǰ������ʩ��ʵ��� δ��ʵ �������
	var NurHeadBefPreventMeasures="";   //id���Ժ�����ַ�����ͷ
	if($("#NurHeadBefPreventMeasures-99890").is(':checked')){
		$("input[type=checkbox][id^='NurHeadBefPreMeaReason-']").each(function(){
			if($(this).is(':checked')){
				NurHeadBefPreventMeasures=this.value;
			}
		})
		if(NurHeadBefPreventMeasures==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("����ǰ������ʩ��ʵ���")+"��"+$g("��ѡ")+$g('δ��ʵ')+"��"+$g("����ǰ������ʩδ��ʵ��ԭ��-�������")+$g('����')+"��");	
			return false;
		}
	}	
	
	return true;
}
//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	//����ǰ������ʩ��ʵ��� δ��ʵ �������
	$("input[type=radio][id^='NurHeadBefPreventMeasures-']").each(function(){
		if ($(this).is(':checked')){
			var id=this.id;
			if (id=="NurHeadBefPreventMeasures-99890"){
				$("input[type=checkbox][id^='NurHeadBefPreMeaReason-']").attr("disabled",false);
			}else{
				$("input[type=checkbox][id^='NurHeadBefPreMeaReason-']").removeAttr("checked"); //����ǰ������ʩδ��ʵ��ԭ��
				$("input[type=checkbox][id^='NurHeadBefPreMeaReason-']").attr("disabled",true); 
				$("#NurHeadBefPreMeaReason-99900").nextAll(".lable-input").val(""); //����ǰ������ʩδ��ʵ��ԭ�� ����
				$("#NurHeadBefPreMeaReason-99900").nextAll(".lable-input").hide(); 
				
			}
			if(EvaRecordId!="")	{
				$("input[type=checkbox][id^='BefPreMeaReason-']").attr("disabled",true); 
			}
		}
	})
	//����ǰ������ʩδ��ʵ��ԭ��
	$("input[type=checkbox][id^='NurHeadBefPreMeaReason-']").each(function(){
		if ($(this).is(':checked')){
			$("input[type=radio][id='NurHeadBefPreventMeasures-99890']").prop("checked",true) ;
		}
	})
}

function add_event(){
	AllStyle("textarea","",100);
	chkTableDate("NurDepRecord-94470-94476-94480");
	//���ڿ���
	/*$("input[id^='NurDepRecord-94470-94476-94480']").each(function(){
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
	})*/ 
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
			return ;
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
			return ;
		}
		if(jsonString.ErrCode == 0){
			SaveAsse(1);
		}
	},"json",false);
		
}
//ʱ�� ����У��
function CheckTimeornum(){
	//ʱ������У��
	//����ʱ��
	chktime("NurDepMeetTime","NurDepMeetDate");
	
}

//��Ա�س��¼����ش���
function StaffEnter()
{
	$('#staffwin').show();
	$('#staffwin').window({
		title:$g('������Ա��Ϣ'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:500,
		height:400
	 }); 
    $('#staffwin').window('open');
    $("#UserNames").val("");
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
	$("#UserNames").val($("#NurDepParticipants").val()); /// ����������Ա����������Ա��ֵ(���Ĳλ���Ա)
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
  $("#NurDepParticipants").val(userName)	
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

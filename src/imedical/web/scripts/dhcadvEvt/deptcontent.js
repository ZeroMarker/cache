/// Description: ҽ����˽���
/// Creator: yangyongtao
/// CreateDate: 2019-03-27
var nowDate=formatDate(0); //ϵͳ�ĵ�ǰ����
var EvaRecordId="",LinkRecordId="",WinCode=""; //AuditList="",CancelAuditList="",StaFistAuditUser="",StsusGrant="",RepStaus="";
var userName="";
$(document).ready(function(){
	$.messager.defaults = { ok: $g("ȷ��"),cancel: $g("ȡ��")};
	EvaRecordId=getParam("recordId");  //������id
	LinkRecordId=getParam("LinkRecordId");  //��������¼ID
	//AuditList=getParam("AuditList");  //��˴�
	//CancelAuditList=getParam("CancelAuditList");  //������˴�
	//StaFistAuditUser=getParam("StaFistAuditUser");  //��һ������
	//StsusGrant=getParam("StsusGrant");  //��˱�ʶ
	//RepStaus=getParam("RepStaus");  //����״̬
	WinCode=getParam("code");  //��������¼code
	$("#AsseSaveBut").on("click",function(){
		SaveAsse();
	})
 
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
	
	getInfo(0);

});
//�������۱���
function SaveAsse(flag)
{
	 ///����ǰ,��ҳ���������м��
	if(!(checkRequired())){
		return;
	} 
	
	var msg=checkTableRequired();
	if(msg!=""){
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
			if (data[0]=="0") {
				window.parent.closeDeptConWindow();

			}else{
				$.messager.alert($g("��ʾ:"),$g("����ʧ��"));
				return;
			}
		},"text")
			
}
//����
function add_event(){
	getInfo(1);
}

//��ȡ��ǰ��¼�û�������
function getInfo(flag){
	// ��ȡ��¼�� ��Ϣ
	runClassMethod("web.DHCADVCOMMONPART","GetRepUserInfo",{'UserID':LgUserID,'LocID':LgCtLocID,'HospID':LgHospID,'GroupID':LgGroupID},
	function(Data){ 
		LgUserName=Data.User;
	},"json",false);
	if(EvaRecordId!="")	{
		//�ֳ���������  ���ɱ༭
		$("[id^='DeptContent-3979-']").each(function(){
			if ((this.value!="")){
				var rowid=this.id.split(".")[0];
				var rownum=this.id.split(".")[1];
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='DeptContent-3979-3986']").datebox({"disabled":true});
				if(flag==0){
					$('a:contains('+$g("ɾ��")+')').parent().hide();
				}
			}
		})		
	}	
	$("#DeptContent").next().find("tbody>tr").each(function(j,obj){
		if($(obj).find("input[id^='DeptContent-3979-3985.']").val()==""){
		  $(obj).find("input[id^='DeptContent-3979-3985.']").val(LgUserName);
		  $(obj).find("input[id^='DeptContent-3979-3985.']").attr("readonly",'readonly');
		}
		if($(obj).find("input[id^='DeptContent-3979-3986.']").val()==""){
		  $(obj).find("input[id^='DeptContent-3979-3986.']").datebox({"disabled":true});
		  $(obj).find("input[id^='DeptContent-3979-3986.']").datebox("setValue",nowDate);
		}
	})
	
}

function checkTableRequired(){
	var errMsg="",lenflag="";
	
	$("#DeptContent").next().find("tbody tr").each(function(i){
		if(lenflag==""){
							
			var rowMsg="";
			// ׷������
			var str1=$(this).children('td').eq(0).find("textarea").val();
			if(str1.length==0){
				rowMsg=rowMsg+$g("����׷������")+",";
			}
			if(str1.length>2000){
				lenflag="-1";
				$.messager.alert($g("��ʾ:"),$g("׷�����ݹ��࣬����ʧ��"));
				return;
			}
			// ׷����
			var str2=$(this).children('td').eq(1).find("input").val();
			if(str2.length==0){
				rowMsg=rowMsg+$g("׷����")+",";
			}
			//׷������
			//var str3=$(this).children('td').eq(2).find("datebox").getValue() //getValue() //("datebox").val()
			//if(str3.length==0){
			  // rowMsg=rowMsg+"׷������,"
			//}
			
			
			if(rowMsg!=""){
				errMsg=errMsg+"\n"+rowMsg+$g("����Ϊ��")+".";
			}
		}
			
				
	})
	if(errMsg!=""){
		$("html,body").stop(true);$("html,body").animate({scrollTop: $("#DeptContent").offset().top}, 0);
		$.messager.alert($g("��ʾ:"),errMsg);
	}
	if(lenflag!=""){
		errMsg=lenflag;
	}
	return errMsg;
}

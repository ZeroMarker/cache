/// creator:dws
/// 2017-02-12
/// Descript:�������

var praiseNum="";
//var repType=""; //����&����
$(function(){
	InitUICheckBox();
	InitFaileReasonCombobox()
	//getNowDateTime(); //��ȡ���۵�ǰ����ʱ��
	//btnFun(); //���۱�����ȡ��
	//getAllSignPraise(); //��ȡ��������ģ����������
	orNotAppraise();
});
function InitFaileReasonCombobox()
{
	$('#FaileReason').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISAffirmStatus&MethodName=getFailReason',
		required : true,
	    idField:'id',
	    fitColumns:true,
	    fit: true,//�Զ���С  
		panelWidth:150,
		panelHeight:150,
		textField:'name',
		mode:'remote',
		valueField:'value',											
		textField:'text',
		onSelect:function(){
		varSelect = $(this).combobox('getValue');
		}
	});
}

///��ȡ��ǰ����ʱ��
function getNowDateTime(){
	//��ȡ��ǰ����ʱ��
	function p(s) {
    	return s < 10 ? '0' + s: s;
	}
	var nowDate = new Date();
	//��ȡ��ǰ��
	var year=nowDate.getFullYear();
	//��ȡ��ǰ��
	var month=nowDate.getMonth()+1;
	//��ȡ��ǰ��
	var date=nowDate.getDate(); 
	var h=nowDate.getHours();       //��ȡ��ǰСʱ��(0-23)
	var m=nowDate.getMinutes();     //��ȡ��ǰ������(0-59)
	var s=nowDate.getSeconds();     //��ȡ��ǰ����(0-59)
	var nowDateTime=year+'-'+p(month)+"-"+p(date)+" "+p(h)+':'+p(m)+":"+p(s);
	return nowDateTime;
}
function ComfimDis(flag)
{
	var RaNubmer=$("#lb_Num").text(); //���۵÷�		sufan 2017-12-15
	//alert(appDateTime)
	if(RaNubmer=="")
	{
		$.messager.alert("��ʾ","���۵÷ֲ���Ϊ��!");
		return;
	}
	if(mainRowID.indexOf("$")!=-1){
		var mainIDarray=mainRowID.split("$")
		for(i = 0;i < mainIDarray.length; i++) 
		{
			DisEvaluate(flag,mainIDarray[i])
		}
	}else{
			DisEvaluate(flag,mainRowID)
		}
}


///���۱��淽��
///sufan 2017-12-15
function DisEvaluate(flag,DismainRowID)
{
	if(flag==0){
		var statuscode=13;
	}else{
		var statuscode=14;
	}
	var dataNum="";
	for(var j=0;j<praiseNum;j++){
		var haveSelectColor=$("#tag").children().eq(j).css('background-color'); //��ѡ�е�����ģ��
			   
		if((haveSelectColor=="rgb(173, 216, 230)")||(haveSelectColor=="lightblue")){
			dataNum=dataNum+($("#tag").children().eq(j).attr("tempVal"))+"-";
		}
	}
	var RaItemDr=dataNum.substring(0,dataNum.length-1); //������Ŀģ��id
	var RaRemarks=$("#signremark").val(); //��������
	var RaNubmer=$("#lb_Num").text(); //���۵÷�
	var appDateTime=getNowDateTime(); 
	var appDate=(appDateTime.split(" "))[0]; //��������
	var appTime=(appDateTime.split(" "))[1]; //����ʱ��
	var FaileReason=""
	var dataNum=DismainRowID+"&"+RaItemDr+"||"+RaRemarks+"||"+type+"||"+RaNubmer+"&"+appDate+"-"+appTime+"&"+createUser;
	//��������
	var strings=type+"^"+DismainRowID+"^"+RaNubmer+"^"+RaRemarks+"^"+appDate+"^"+appTime+"^"+createUser+"^"+RaItemDr+"^"+statuscode+"^"+FaileReason
	//alert(strings)
	runClassMethod("web.DHCDISAppraise","saveDisappraise",{RaReqType:type,mainRowID:DismainRowID,RaNubmer:RaNubmer,RaRemarks:RaRemarks,appDate:appDate,appTime:appTime,createUser:createUser,RaItemDr:RaItemDr,StatusCode:statuscode,FaileReason:FaileReason},function(jsonObj){
		if(jsonObj==0){
			//$.messager.alert("��ʾ","���۱���ʧ��!");
		}
		else{
			$.messager.alert("��ʾ","���۱���ɹ�!");
			window.location.reload();
			parent.$('#cspAffirmStatusTb').datagrid('reload');
			parent.$('#win').window('close');
		}
	});
}

//���۱�����ȡ��,�鿴
function btnFun(){
	//��������ʱ�洢��ѡ������ģ��id����������
	$("#btnCommit").on('click',function(){
		var AffirmStatu="";
    	$("input[type=checkbox][name=disaffirm]").each(function(){
			if($(this).is(':checked')){
				AffirmStatu=this.value;
			}
		});
		var statuscode=""
		if(AffirmStatu==0)
		{
			statuscode=19;
		}
		if(AffirmStatu==""){
			statuscode=16;
		}
		
		var dataNum="";
		for(var j=0;j<praiseNum;j++){
			var haveSelectColor=$("#tag").children().eq(j).css('background-color'); //��ѡ�е�����ģ��
			   
			if((haveSelectColor=="rgb(173, 216, 230)")||(haveSelectColor=="lightblue")){
				dataNum=dataNum+($("#tag").children().eq(j).attr("tempVal"))+"-";
			}
		}
		//getRepType(); //��ȡ���ͻ����ͱ��
		var RaItemDr=dataNum.substring(0,dataNum.length-1); //������Ŀģ��id
		var RaRemarks=$("#signremark").text(); //��������
		//var RaReqType=type; //pei������
		var RaNubmer=$("#lb_Num").text(); //���۵÷�
		var appDateTime=getNowDateTime(); 
		var appDate=(appDateTime.split(" "))[0]; //��������
		var appTime=(appDateTime.split(" "))[1]; //����ʱ��
		var FaileReason=$('#FaileReason').combobox('getValue')
		if((statuscode==19)&&(FaileReason==""))
		{
			$.messager.alert("��ʾ:","��ѡ��ԭ��!");
			return;
		}
		
		var dataNum=mainRowID+"&"+RaItemDr+"||"+RaRemarks+"||"+type+"||"+RaNubmer+"&"+appDate+"-"+appTime+"&"+createUser;
		//��������
		var strings=type+"^"+mainRowID+"^"+RaNubmer+"^"+RaRemarks+"^"+appDate+"^"+appTime+"^"+createUser+"^"+RaItemDr+"^"+statuscode+"^"+FaileReason
		//alert(strings)
		runClassMethod("web.DHCDISAppraise","saveDisappraise",{RaReqType:type,mainRowID:mainRowID,RaNubmer:RaNubmer,RaRemarks:RaRemarks,appDate:appDate,appTime:appTime,createUser:createUser,RaItemDr:RaItemDr,StatusCode:statuscode,FaileReason:FaileReason},function(jsonObj){
			if(jsonObj==0){
				$.messager.alert("��ʾ","���۱���ʧ��!");
			}
			else{
				$.messager.alert("��ʾ","���۱���ɹ�!");
				window.location.reload();
			}
		});
	});
	//ȡ������
	$("#btnCancel").on('click',function(){
		window.location.reload();
	});	
	
}


//��ȡ��������ģ����������
function getAllSignPraise(){
	runClassMethod("web.DHCDISAppraise","getSignModuleDesc",{},function(jsonObj){
		praiseNum=jsonObj.total;
		for(var i=0;i<praiseNum;i++){
			$("#tag").append('<span class="tag" tempVal='+jsonObj.rows[i].AIRowId+' onclick="changePraiseStatus(this);">'+jsonObj.rows[i].AIDesc+'</span>');
		}
	});
}

//ѡ������ģ����ʽ�����仯
function changePraiseStatus(obj){   //rgb(173, 216, 230)
	var backGround=$(obj).css('background-color'); //�����ģ�鱳��ɫ
	var noStatusColor1="rgb(205, 230, 156)"; //δѡ�е���ɫ(IE11)
	var noStatusColor2="#cde69c"  ////δѡ�е���ɫ(IE8)
	var haveStatusColor1="rgb(173, 216, 230)";  //ѡ�е���ɫ(IE11)
	var haveStatusColor2="lightblue";  //ѡ�е���ɫ(IE8)
	
	if((backGround==haveStatusColor1)||(backGround==haveStatusColor2)){
		$(obj).css('background-color','#cde69c')
	}
	if((backGround==noStatusColor1)||(backGround==noStatusColor2)){
		$(obj).css('background-color','lightblue')
	}
}
///��д��д����
//�жϸ��û��Ƿ��Ѿ����۹������뵥
function orNotAppraise(){
	//getRepType(); //��ȡ���ͻ����ͱ��
	//alert(mainRowID+","+createUser+","+type)
	runClassMethod("web.DHCDISAppraise","orNotAppraise",{mainRowID:mainRowID,LgUserID:createUser,repType:type},function(data){
		//�Ѿ����۹������뵥��ֱ�ӵ㿪�Ϳ��Բ鿴��������
		if(data>0){
			getPraiseInfo();
			$("#btnCommit").linkbutton("disable");
			$("#btnCommit").unbind();
			$("#btnCancel").linkbutton("disable");
			$("#btnCancel").unbind();
		}	
		//���뵥δ���۹�����������
		else{
			getAllSignPraise();
		}		
	});
}

//��ȡ�Ѿ����۹������뵥�����Ϣ
function getPraiseInfo(){
	//getRepType(); //��ȡ���ͻ����ͱ��
	runClassMethod("web.DHCDISAppraise","getPraiseInfo",{mainRowID:mainRowID,repType:type},function(data){
		$("#rate-comm-1").html("");
		//alert(data.rows[0].RaNubmer);
		if(data.rows[0].RaNubmer==1){
			$("#rate-comm-1").append('<span><img src="../images/1.png"></span>');
			$("#signpraise").text("�ǳ���,�д���ߣ�");
		}else if(data.rows[0].RaNubmer==2){
			$("#rate-comm-1").append('<span><img src="../images/2.png"></span>');
			$("#signpraise").text("�ܲ�,����Ľ���");
		}else if(data.rows[0].RaNubmer==3){
			$("#rate-comm-1").append('<span><img src="../images/3.png"></span>');
			$("#signpraise").text("һ��,ϣ���������ƣ�");
		}else if(data.rows[0].RaNubmer==4){
			$("#rate-comm-1").append('<span><img src="../images/4.png"></span>');
			$("#signpraise").text("�ܺ�,����Ŭ����");
		}else if(data.rows[0].RaNubmer==5){
			$("#rate-comm-1").append('<span><img src="../images/5.png"></span>');
			$("#signpraise").text("�ǳ���,�޿����ޣ�");
		}
			
		$("#tag").html("");
		//�������۱�ǩ
		for(var j=0;j<data.rows[0].RaItemDr.length;j++){
			$("#tag").append('<span class="tagApp">'+data.rows[0].RaItemDr[j].signName+'</span>');
		}
		$("#FaileReason").combobox({disabled:true});
		var ReasonDr=data.rows[0].ReasonDr
		if(ReasonDr!="")
		{
			var ReasonDr=1;
			$("#FaileReason").combobox("setValue",ReasonDr);
		}
		var AffirmType=data.rows[0].AffirmType
		if(AffirmType!="")
		{
			$('#AFFIRM'+AffirmType).attr("checked",true);
		}
		$("#signremark").val(data.rows[0].RaRemarks); //���ر�ע
		$("#signremark").attr("disabled",true);
		$("#AFFIRM0").attr("disabled",true);
		//$("#AFFIRM1").attr("disabled",true);
		
		
	});
}
function InitUICheckBox()
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
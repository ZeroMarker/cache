
/**
*Description:	��ҽ��Ѫ�����¼����浥
*Creator: 		Qunianpeng
*CreDate: 		2018-05-25
**/
var RepDate=formatDate(0);			// ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	InitButton();					// ��ʼ����ť
	reportControl();				// ������ 
	InitCheckRadio(); 	
	InitReport(recordId);			// ����ҳ����Ϣ
	add_event();
})


function InitButton(){
	
	// ����
	$("#SaveBut").on("click",function(){
		SavePipeReport(0);
	})
	
	// �ύ
	$("#SubmitBut").on("click",function(){
		SavePipeReport(1);
	})	
	
}

// ������
function reportControl(){
	
	// ��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
		});
	});
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});

	// ��Ѫ������Ӧʱ�����
	chkdate("AdvBloodSereaOccTime");

	/* 2018-06-06 ��ɾ�����ӵ�table����*/
	$(".dhc-table>tbody td>input").css({"margin-left":"-10px"})
	//��Ѫ��ʼ���ڿ���
	$("input[id^='BloodGiveList-97701-97708-97715']").datetimebox().datetimebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	//��Ѫ�������ڿ���
	$("input[id^='BloodGiveList-97701-97709-97716']").datetimebox().datetimebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	///������Ѫ������Ӧʱ��sufan 2019-11-12
	if(!$('input[id^="AdvBloodsereactions"][type="radio"]:checked').length){
		$('#AdvBloodSereaOccTime').datebox({disabled:'true'});//��Ѫ������Ӧʱ��
	}
	
	///��Ѫǰ�����¿��� sufan 2019-11-12
	$('input[id^="BloodForTemperatureChange"]').blur(function(){
		var tempval = $(this).val();
		if((tempval<34)||(tempval>43)){
			$.messager.alert("��ʾ","����Ӧ��34-43������������!");
			$(this).val("");
			return false;
		}
	})
	
	///�в�ʷ����  sufan 2019-11-14
	$('input[id^="isPregnancy"][type="radio"]').click(function(){
		if($(this).val()=="��"){
			$('input[id^="isGive"][value="��"]').attr('checked','true');
		}
	})
	
	$('input[id^="isGive"][type="radio"]').click(function(){
		if($(this).val()=="��"){
			$('input[id^="isPregnancy"][value="��"]').attr('checked','true');
		}else{
			$('input[id^="isPregnancy"][value="��"]').attr('checked','true');
		}
	})
	TableControl();
}

// ���ر�����Ϣ
function InitReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//������Ϣ
    	$("#from").form('validate');				
	} 
}

//���汣��
function SavePipeReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert("��ʾ:","��������Ϊ�գ�������ǼǺ�/�����Żس�ѡ���¼¼�뻼����Ϣ��");	
		return false;
	}
	///����ǰ,��ҳ���������м��
	if(!(checkRequired()&&checkother())){
		return;
	}
	SaveReportCom(flag);
}

//������Ϣ��ֵ���س��¼���
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
  	$("#from").form('validate'); 
}
function add_event(){
	//reportControl();
	/* 2018-06-06 ��ɾ�����ӵ�table����*/
	$(".dhc-table>tbody td>input").css({"margin-left":"-10px"})
	 //����
	 $("input[id^='BloodGiveList-97701-97708-97715']").each(function(){
		if((this.id.split("-").length==4)){
			var BloodDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (BloodDate!=""){
				$("#"+this.id).datebox("setValue",BloodDate);
			}else{
				$("input[id^='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
					}
				});
			}
		}
	}) 
	//��������
	 $("input[id^='BloodGiveList-97701-97709-97716']").each(function(){
		if((this.id.split("-").length==4)){
			var BloodDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (BloodDate!=""){
				$("#"+this.id).datebox("setValue",BloodDate);
			}else{
				$("input[id^='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
					}
				});
			}
		}
	}) 
	
	
	$("input[id^='BloodGiveList-97701-97703-97710']").live('keydown',function(event){	
		if(event.keyCode == "13"){
			if(EpisodeID==""){
				$.messager.alert('��ʾ:','����ѡ���߾����¼��');
				return;
			}
			ShowBldWin()
		}
    });
    TableControl();
	
}
function ShowBldWin(){
	
	$('#bldwin').show();
	$('#bldwin').window({
		title:'��Ѫ���б�',
		collapsible:true,
		closed:"true",
		modal:true,
		minimizable: false, 
		maximizable: false,
		resizable: false,
		width:600,
		height:400
	}); 

	$('#bldwin').window('open');
	SetBldTxtVal(this.id);
}
//��Ѫ�� 2016-10-25
function SetBldTxtVal(BloodGiveListID)
{
	
	var columns = [[
		{field:'issueId',title:'��Ѫ��ID',width:60}, 
		{field:'issueDate',title:'��������',width:80}, 
		{field:'issueTime',title:'����ʱ��',width:80},
		{field:'IsTransBlood',title:'�Ƿ��м�����Ѫʷ',width:80},
		{field:'IsReaction',title:'�Ƿ�����Ѫ��Ӧʷ',width:80},
		{field:'Parity',title:'�д�',width:80},
		{field:'Gravidity',title:'����',width:80}
	]];
	//����datagrid
	$('#bldgrid').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetPatBldRecordNew&EpisodeID='+EpisodeID,	
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:200,  // ÿҳ��ʾ�ļ�¼����
		pageList:[200,400],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onDblClickRow: function (rowIndex, rowData) 
		{
			var issueId=rowData.issueId; //��Ѫ��id
			if((issueId!="")&&(issueId!=undefined)){
				$('#BB'+rowData.IsTransBlood).attr("checked",true); 	//������Ѫʷ BloodtransfusionHistory-label-97440
				if((rowData.IsTransBlood!="��")&&(rowData.Parity!=undefined)){
					$('#BloodtransfusionHistory-label-97440').attr("checked",true);//������Ѫʷ ��
				}else{
					$('#BloodtransfusionHistory-label-97443').attr("checked",true);//������Ѫʷ ��
				}
				if((rowData.Parity!="0")&&(rowData.Parity!=undefined)){
					$('#isPregnancy-97293').attr("checked",true);//��ʷ ��
				}else{
					$('#isPregnancy-97294').attr("checked",true);//��ʷ ��
				}
				if ((rowData.Gravidity!="0")&&(rowData.Gravidity!=undefined)){
					$('#isGive-97307').attr("checked",true);//��ʷ ��
				}else{
					$('#isGive-97308').attr("checked",true);//��ʷ ��
				}
				$.each($('input[id^="BloodtransfusionHistory-label"]:checked'),function(){   //sufan 2019-11-14 �к�ߵĺ��������
						showPre(this);
				})
				GetbldBldTypedgInfo(issueId,BloodGiveListID);
			}
  			$('#bldwin').window('close');
		}
	});		 
	
}
			
//��ȡ��Ѫ����Ϣ��ʼ����Ѫ��Ϣ�б�  2016-10-27
function GetbldBldTypedgInfo(issueId,BloodGiveListID)
{  
	var BldList="";
	//	Ѫ����Ϣ(Ѫ����� ^ Ѫ������(Ѫ��Ʒ)^Ѫ��^��Ѫ����^Ѫ��Ѫ��)  ���������ݣ��� $$ ���зָ�
	runClassMethod("web.DHCADVINTERFACE","GetPatBldRecordPacksList",{'BldRecordId':issueId},
		function(val){ 
			BldList=val;
		},"text",false)
	if(BldList==""){
		$.messager.alert('��ʾ:','����Ѫ����Ѫ����Ϣ��������ѡ��');
		return;
	}
	var BldListArr=BldList.split("$$")
	var Bldlen=BldListArr.length; //��Ѫ��¼���� ʵ����1
	
	var num=0,rowid="",rownum="";
	$("input[id^='BloodGiveList-97701-97703-97710']").each(function(){
			num=num+1;
	})
	for(var k=1;k<=Bldlen;k++){
		if(k>num){
			$('a:contains("����")').click(); //�Զ����������
		}
	}
	$("input[id^='BloodGiveList-97701-97703-97710']").each(function(){
		if(rowid==""){
			rowid=this.id.split(".")[0];
		}else{
			rowid=rowid+"^"+this.id.split(".")[0];
		}
		if(rownum==""){
			rownum=this.id.split(".")[1];
		}else{
			rownum=rownum+"^"+this.id.split(".")[1];
		}
	})
	for(var k=0;k<Bldlen;k++){
		var BldpackID=BldListArr[k].split("^")[0]; //Ѫ�����
		var BloodProductName=BldListArr[k].split("^")[1]; //Ѫ������(Ѫ��Ʒ)
		var BDType=BldListArr[k].split("^")[2].split("��")[0]+"��"; //Ѫ��
		var BDTypeHD=BldListArr[k].split("^")[2].split("��")[1]; //������
		var packVolumn=BldListArr[k].split("^")[4]; //Ѫ��Ѫ��
		var rowidarr=rowid.split("^"),rownumarr=rownum.split("^");
		var value=$("input[id^='BloodGiveList-97701-97703-97710']input[id$='"+rownumarr[k]+"']").val();
		
		//if(value==""){
			$("input[id^='BloodGiveList-97701-97703-97710']input[id$='"+rownumarr[k]+"']").val(BldpackID);
			$("input[id^='BloodGiveList-97701-97704-97711']input[id$='"+rownumarr[k]+"']").val(BloodProductName);
			$("input[id^='BloodGiveList-97701-97705-97712']input[id$='"+rownumarr[k]+"']").val(BDType);
			$("input[id^='BloodGiveList-97701-97706-97713']input[id$='"+rownumarr[k]+"']").val(BDTypeHD);
			$("input[id^='BloodGiveList-97701-97707-97714']input[id$='"+rownumarr[k]+"']").val(packVolumn);
		//}
		if((BldList!="")&&(Bldlen==num)){ //��λ������ת��������ͬʱ���������һ������
			//$("input[id^='BloodGiveList-97701-97703-97710']input[id$='"+rownumarr[num]+"']").parent().parent().hide();
		}
		$("input[id^='"+rowidarr[k]+"']input[id$='"+rownumarr[k]+"']").attr('readonly','readonly')
		//$('a:contains("����")').parent().hide();
		//$('a:contains("ɾ��")').parent().hide();
	}
	TableControl();
			
}
function TableControl(){
	// ���� �Ƿ������ֹ�����ҽ�� ����
	    $("[id^='BloodGiveList-97701-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value=="")){
				if ((MKIOrdFlag!="1")&&(rowid!="BloodGiveList-97701-97703-97710")){
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				}else{
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",false);
				}
			}else{
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				/* if((rowid=="SuspectNewDrug-96655")||(rowid=="SuspectNewDrug-96656")){
					$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				} */
			}
		})
		
}

//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	$("input[type=radio][id^='AdvBloodsereactions-']").each(function(){
		if ($(this).is(':checked')){
			//�Ƿ���Ѫ������Ӧ
			if(this.id=="AdvBloodsereactions-97446"){ //��
				$('#AdvBloodSereaOccTime').datebox({disabled:'true'});//��Ѫ������Ӧʱ��
				$("#AdvBloodSereaOccTime").datebox("setValue","");  //����ֵ����Ϊ��
			}
			if(this.id=="AdvBloodsereactions-97445"){ //��
				$('#AdvBloodSereaOccTime').datebox({disabled:false});//��Ѫ������Ӧʱ��
			}
			
		}
	})
}
///�ж���Ѫ�б��Ƿ�Ϊ�� sufan 2019-11-14
function checkother()
{
	//������Ѫ�б���Ϊ��
	var ret=1
	$("input[id^='BloodGiveList-97701-97704-97711']").each(function(){
			if($(this).val()=="")
			{
				return true;
			}else{
				ret=0
			}
			
	})
	if(ret==1){
		if(MKIOrdFlag!="1"){
			$.messager.alert("��ʾ:","��ά����Ѫ��¼�����б��ֶ�������Ѫ��Ϣ��Ч����س�ѡ����Ѫ������");
		}else{
			$.messager.alert("��ʾ:","��ά����Ѫ��¼�����б�������Ѫ��Ϣ�٣��貹����Ϣ����");
		}
		return false;
		
	}
	///������Ѫ�б���Ѫ��ʼ���ںͽ�������
	var num=0,rowid="",rownum="";
	$("input[id^='BloodGiveList-97701-97703-97710']").each(function(){
			num=num+1;
	})
	$("input[id^='BloodGiveList-97701-97703-97710']").each(function(){
		if(rowid==""){
			rowid=this.id.split(".")[0];
		}else{
			rowid=rowid+"^"+this.id.split(".")[0];
		}
		if(rownum==""){
			rownum=this.id.split(".")[1];
		}else{
			rownum=rownum+"^"+this.id.split(".")[1];
		}
	})
	rownumarr=rownum.split("^");
	var clorec=0;
	for(var i=0;i<num;i++){
		var stDateTime=$("input[id^='BloodGiveList-97701-97708-97715'][id$='"+rownumarr[i]+"']").datetimebox('getValue');
		var endDateTime=$("input[id^='BloodGiveList-97701-97709-97716'][id$='"+rownumarr[i]+"']").datetimebox('getValue');
		if(!DateTimecontrast(stDateTime,endDateTime)){
			clorec=i+1;
			break;
		}
	}
	if(clorec>0){
		$.messager.alert("��ʾ:","��Ѫ�б��"+clorec+"����Ѫ��ʼʱ�������Ѫ����ʱ�䣡");
		return false;
	}
	return true;
}
function DateTimecontrast(stDateTime,endDateTime)
{
	var ret=1;
	var reg = new RegExp(":","g")
	var stDate=stDateTime.split(" ")[0];
	var stTime=stDateTime.split(" ")[1]==undefined?"":stDateTime.split(" ")[1].replace(reg,"");
	var endDate=endDateTime.split(" ")[0];
	var endTime=endDateTime.split(" ")[1]==undefined?"":endDateTime.split(" ")[1].replace(reg,"");
	if(stDate>endDate){
		ret=0;
	}else if((stDate==endDate)&&(stTime>endTime)){
		ret=0
	}else{
		ret=1;
	}
	return ret;
}

var EpisodeID="";         //ҽ��ID
var UserId=LgUserID     //�û�ID 
var columns= [
		{field: 'patVisitStat',title: '����״̬'},
		{field: 'statDate',title: '״̬����'},
		{field: 'statTime',title: '״̬ʱ��'},
		{field: 'admLocDesc',title: '���˿���'},
		{field: 'userDesc',title: '������'}, 
		{field: 'inWardDesc',title: '��Ժ����'},
		{field: 'patRegNo',title: '�ǼǺ�'}, 
		{field: 'patientName',title: '����'}];
$(document).ready(function(){
		EpisodeID=51;
		initMe();
		$('#fromDate').dhccDate()	//��ʼ������ʽ
		$('#toDate').dhccDate()	//����������ʽ
		
		$('#Regno').bind('keypress',function(event){
        	if(event.keyCode == "13"){
            	RegNoBlur(); 
        	}
    	});
		
		//����״̬
		$('#visitStat').dhccSelect({
			url:LINK_CSP+"?ClassName=web.DHCEMPatStatusQuery&MethodName=ListPsa"
		})
		
		//����
		$('#find').click(function(){
			SearchClick();	
		})
		
		//����
		$('#clearScreen').click(function(){
			ClearScreen();	
		})
		
		$('#demo-editable').dhccTable({
	    //height:$(window).height()-300,
	    //sidePagination:'side',
	    height:$(window).height()-120,
        url:'dhcapp.broker.csp?ClassName=web.DHCEMPatStatusQuery&MethodName=FindAdmVisitStat&EpisodeID=51'+'&fromDate='+""+'&toDate='+""+'&visitStat='+"",
        columns:columns,
        singleSelect:true
    }); 
})

//��ʼ������
function initMe(){
		$('#EpisodeID').val(EpisodeID);	//����id
		var objRegNo=document.getElementById("Regno");	//�ǼǺ�
		if (objRegNo){
			objRegNo.onblur=RegNoBlur;
	    	if ($('#EpisodeID').val()!=""){	//�ǼǺ�
		  		var retStr=MyRunClassMethod("web.DHCEMPatStatusQuery","GetRegNoFromAdm",{'EpisodeID':EpisodeID});
		   		if (retStr!=""){
			   		objRegNo.value=retStr;
			   		//preRegNo=retStr;
			   		BasPatinfo(retStr);
			   	}else {
			  		$('#EpisodeID').val("")
			  	}
	     }
	    var objSearch=document.getElementById("find");	//���Ұ�ť
	    //if (objSearch){
		   // objSearch.onclick=SearchClick;
		 //}
    }   	 
}

//�ǼǺ�ʧȥ�����¼�
function RegNoBlur()
{
    $('#patMainInfo').val("");
    var objRegNo=document.getElementById("Regno");
    var retStr=MyRunClassMethod("web.DHCEMPatStatusQuery","GetRegNoFromAdm",{'EpisodeID':EpisodeID});
    if (objRegNo.value==retStr){
     	return;
    }
	var isEmpty=(objRegNo.value=="");
    var oldLen=objRegNo.value.length;
	if (!isEmpty) {  //add 0 before regno
	    //for (i=0;i<8-oldLen;i++)
	    for (var i=0;i<10-oldLen;i++)
	    {
	    	objRegNo.value="0"+objRegNo.value  
	    }
	}
    //preRegNo=objRegNo.value;
   	BasPatinfo(objRegNo.value);
    $("#EpisodeID").val("");
   	//Search(true);
}

//������Ϣ
function BasPatinfo(regNo)
{//    s str=regno_"^"_$P(ctloc,"-",2)_"^"_$G(room)_"^"_$G(sex)_"^"_$G(patName)_"^"_$G(Bah)_"^"_$G(bedCode)_"^"_$G(age)_"^"_$G(WardDes)_"^"_homeaddres_"^"_hometel_"  "_worktel_"  "_handtel
	//alert(regNo);
	if (regNo==""){
		return;
	}
 	var str=MyRunClassMethod("web.DHCEMPatStatusQuery","GetPatInfo",{'curId':regNo,'transLocNum':""});
   	if (str=="") return;
    var tem=str.split("^");
	$('#patMainInfo').val(tem[4]+","+tem[3]+","+tem[7])   //+t['val:yearsOld'] 
}

//��ѯ�¼�
function SearchClick(){
	//var status=$("#visitStat option:selected").text();
	var status=$("#visitStat").val();
	var retStr=MyRunClassMethod("web.DHCEMPatStatusQuery","GetRegNoFromAdm",{'EpisodeID':51});
		   if (retStr!=""){
			   	$('#Regno').val(retStr);
			   	//preRegNo=retStr;
			   	BasPatinfo(retStr);
			}
	$('#demo-editable').dhccQuery({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatStatusQuery&MethodName=FindAdmVisitStat&EpisodeID=51'+'&fromDate='+""+'&toDate='+""+'&visitStat='+status
	})
	
}

//�����¼�
function ClearScreen()
{
	$('#Regno').val("");		//�ǼǺ�
	//document.getElementById("CardNo").value="";
	$('#EpisodeID').val("");	//����id
	$('#patMainInfo').val("");	//������Ϣ
	$('#fromDate input').val("");	//��ʼ����
	$('#toDate input').val("");	//��������
	$('#visitStat').html("");	//����״̬
	$('#demo-editable').dhccQuery({
        url:'dhcapp.broker.csp?ClassName=web.DHCEMPatStatusQuery&MethodName=FindAdmVisitStat&EpisodeID='+""+'&fromDate='+""+'&toDate='+""+'&visitStat='+""
    }); 
}
/// ֱ��ִ�з������ػص��������ص�dataֵ
function MyRunClassMethod(ClassName,MethodName,Datas){
   Datas=Datas||{};
   var RtnStr = "";
   runClassMethod(ClassName,MethodName,
   Datas,
   function (data){
	  	RtnStr=data;
	  },
	"text",false
	);
	return RtnStr;
}










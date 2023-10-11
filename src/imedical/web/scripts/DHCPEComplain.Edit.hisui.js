
//����  DHCPEComplain.Edit.hisui.js
//����	���Ͷ�߹���
//����	2023.02.09
//������  ln
$(function(){
	
	InitCombobox();
		
	//����
	$("#Update").click(function() {	
		Update_click();		
        });

	//����
	$("#Clear").click(function() {	
		Clear_click();		
        });
        
    $("#RegNo").keydown(function(e) {	
			if(e.keyCode==13){
				RegNoChange();
				}
	});
        
    /*$("#CType").combobox({
		onSelect: function () {
			CType_change();
		}
	}); */
	
    //Ĭ������Ϊ"Ͷ��"
	$("#CType").combobox('setValue', "C");
	iniForm(); 
      	
})

function RegNoChange()
{
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo
		}, false);
		
			$("#RegNo").val(iRegNo)
		}
	
	var BaseInfo=tkMakeServerCall("web.DHCPE.Complain","GetBaseInfoByRegNo",iRegNo);
	var ret=BaseInfo.split("^");
	$("#Name").val(ret[0]);
	$("#IDCard").val(ret[1]);
	
}
function CType_change()
{
	var CType = $("#CType").combobox('getValue');
	if (CType == "C")
	{
		document.getElementById('tComplainUser').innerHTML="Ͷ����";
		document.getElementById('tComplainType').innerHTML="Ͷ������";
		document.getElementById('tComplainObject').innerHTML="Ͷ�߶���";
		document.getElementById('tComplainContent').innerHTML="Ͷ������";
		document.getElementById('tComplainCause').innerHTML="Ͷ��ԭ��";
	}
	else
	{
		document.getElementById('tComplainUser').innerHTML="������";
		document.getElementById('tComplainType').innerHTML="��������";
		document.getElementById('tComplainObject').innerHTML="�������";
		document.getElementById('tComplainContent').innerHTML="��������";
		document.getElementById('tComplainCause').innerHTML="����ԭ��";
	}
	
	
}

function iniForm(){
	
	if (RowId=="") return false;
	
	var ComplainInfo=tkMakeServerCall("web.DHCPE.Complain","GetComplainInfo",RowId);
	
	var ret=ComplainInfo.split("^");
	setValueById("CType",ret[0]);
	setValueById("Source",ret[1]);
	$("#ComplainUser").combogrid('setValue',ret[2]);
	$("#ComplainUserID").val(ret[2]);
	
	setValueById("ComplainType",ret[3]);
	setValueById("ComplainObject",ret[4]);
	
	$("#ComplainContent").val(ret[5]);
	$("#EventTime").datebox('setValue',ret[6])
	setValueById("ComplainCause",ret[7]);
	$("#DisProposal").val(ret[8]);
	$("#Remark").val(ret[9]);
	
	$("#Name").val(ret[10]);
	$("#RegNo").val(ret[11]);
	$("#IDCard").val(ret[12]);
	
	$("#PERecordID").val(ret[13]);
	$('#PERecord').combogrid('grid').datagrid('reload',{'q':ret[18]});
	$("#PERecord").combogrid('setValue',ret[13]);
	
	
	$("#ClaimantName").val(ret[14]);
	$("#ClaimantNo").val(ret[15]);
	setValueById("Relation",ret[16]);
	$("#Tel").val(ret[17]);
	
}

//����������Ϣ
function Clear_click() {
	$("#EventTime").datebox('setValue')
	$("#ComplainContent,#DisProposal,#Remark,#Name,#RegNo,#IDCard,#ClaimantName,#ClaimantNo,#Tel").val("");
    $(".hisui-combobox").combobox('setValue',"");
	$("#ComplainUser").combogrid('setValue',"");
	$("#PERecord").combogrid('setValue',"");	
	
	$("#CType").combobox('setValue',"C");
}


function Update_click() {	
	
	var CType=$("#CType").combobox('getValue');
	if (CType==undefined) {var CType="";}
	
	var Source=$("#Source").combobox('getValue');
	if (Source==undefined) {var Source="";}
	
	var ComplainUser=$("#ComplainUser").combogrid('getValue');
	if (ComplainUser == undefined || ComplainUser == "undefined") { var ComplainUser = ""; }
	if (RowId!="") ComplainUser=$("#ComplainUserID").val(); 
	
	var ComplainType=$("#ComplainType").combobox('getValue');
	if (ComplainType==undefined) {var ComplainType="";}
	
	var ComplainObject=$("#ComplainObject").combobox('getValue');
	if (ComplainObject==undefined) {var ComplainObject="";}
	
	var ComplainContent=$("#ComplainContent").val();
	var EventTime=$("#EventTime").datebox('getValue');
	
	var ComplainCause=$("#ComplainCause").combobox('getValue');
	if (ComplainCause==undefined) {var ComplainCause="";}
	
	var DisProposal=$("#DisProposal").val();
	var Remark=$("#Remark").val();
	
	var Name=$("#Name").val();
	var RegNo=$("#RegNo").val();
	var IDCard=$("#IDCard").val();
	var Record=$("#PERecord").combogrid('getValue');
	if (Record == undefined || Record == "undefined") { var Record = ""; }
	if (RowId!="") {var Record=$("#PERecordID").val(); }
	
	var ClaimantName=$("#ClaimantName").val();
	var ClaimantNo=$("#ClaimantNo").val();
	var Relation=$("#Relation").combobox('getValue');
	if (Relation==undefined) {var Relation="";}
	var Tel=$("#Tel").val();
	if (!CheckTelOrMobile(Tel, "MobilePhone", "")) return false;
	
	var Instring=$.trim(RowId)			        //			    1 
				+"^"+$.trim(CType)			    //����		    2
				+"^"+$.trim(Source)			    //�¼���Դ		3
				+"^"+$.trim(ComplainUser)	    //Ͷ����		4
				+"^"+$.trim(ComplainType)		//Ͷ������		5
				+"^"+$.trim(ComplainObject)		//Ͷ�߶���	    6
				+"^"+$.trim(ComplainContent)	//Ͷ������	    7
				+"^"+$.trim(EventTime)		    //�¼�ʱ��	    8
				+"^"+$.trim(ComplainCause)		//Ͷ��ԭ��	    9
				+"^"+$.trim(DisProposal)		//���ý���	    10
				+"^"+$.trim(Remark)			    //��ע	        11
				+"^"+$.trim(Name)		        //��������		12
				+"^"+$.trim(RegNo)		        //�ǼǺ�		13
				+"^"+$.trim(IDCard)			    //���֤��		14
				+"^"+$.trim(Record)		        //�����¼		15
				+"^"+$.trim(ClaimantName)		//����������	16
				+"^"+$.trim(ClaimantNo)			//֤����		17
				+"^"+$.trim(Relation)			//�뻼�߹�ϵ	18
				+"^"+$.trim(Tel)		        //��ϵ�绰	    19
				;

	var ret=tkMakeServerCall("web.DHCPE.Complain","UpdateComplain",Instring);			
	if(ret.split("^")[0]==-1){
			$.messager.alert('��ʾ',"����ʧ��"+ret.split("^")[1],'error');
			return false;
		}
		else{
			$.messager.popover({msg: '���³ɹ���',type:'success',timeout: 1000});
			Clear_click();
		}
				
	
}


function trim(s) {
	if (""==s) { return "";}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];
}
function InitCombobox()
{
	//����	
	var CTypeObj = $HUI.combobox("#CType",{
        valueField:'id',
        textField:'text',
        panelHeight:'70',
        data:[
           {id:'C',text:$g('Ͷ��')}  
        ]

    });
	
	//�¼���Դ
   var SourceObj = $HUI.combobox("#Source",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=SearchByCode&ResultSetType=array&appcode="+"PEComplain"+"&Paramcode="+"CSource",
		valueField:'TypeValue',
		textField:'ParamValue'
		});
		
	//Ͷ������
   var ComplainTypeObj = $HUI.combobox("#ComplainType",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=SearchByCode&ResultSetType=array&appcode="+"PEComplain"+"&Paramcode="+"CType",
		valueField:'TypeValue',
		textField:'ParamValue'
		});
		
	//Ͷ�߶���
   var ComplainObjectObj = $HUI.combobox("#ComplainObject",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=SearchByCode&ResultSetType=array&appcode="+"PEComplain"+"&Paramcode="+"CObject",
		valueField:'TypeValue',
		textField:'ParamValue'
		});
		
	//Ͷ��ԭ��
   var ComplainCauseObj = $HUI.combobox("#ComplainCause",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=SearchByCode&ResultSetType=array&appcode="+"PEComplain"+"&Paramcode="+"CCause",
		valueField:'TypeValue',
		textField:'ParamValue'
		});
		
	//�뻼�߹�ϵ
   var RelationObj = $HUI.combobox("#Relation",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=SearchByCode&ResultSetType=array&appcode="+"PEComplain"+"&Paramcode="+"CRelation",
		valueField:'TypeValue',
		textField:'ParamValue'
		});
	 
	var LocID=session['LOGON.CTLOCID'];
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
   //Ͷ����
	  var ComplainUserObj = $HUI.combogrid("#ComplainUser",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXTNew",
		mode:'remote',
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=LocID;
			param.hospId = hospId;

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:60},
			{field:'DocName',title:'����',width:200},
			{field:'Initials',title:'����',width:140}	
				
		]]

		});
	
	//�����¼
     var RecordObj = $HUI.combogrid("#PERecord", {
         panelWidth: 400,
         url: $URL + "?ClassName=web.DHCPE.PreIADM&QueryName=FindRecord",
         mode: 'remote',
         delay: 200,
         pagination: true,
         pageSize: 50,
         pageList: [20, 50, 100],
         idField: 'PIADM',
         textField: 'AdmDate',
         onBeforeLoad: function(param) {

             var RegNo=$("#RegNo").val();
	         var IDCard=$("#IDCard").val();
             param.RegNo = RegNo;
             param.IDCard = IDCard;
         },
         onChange: function() {
             
         },
         onShowPanel: function() {
             $('#PERecord').combogrid('grid').datagrid('reload');
         },
         columns: [
             [
                 { field: 'PIADM', hidden: true },
                 { field: 'AdmDate', title: '��������', width: 240 },
                 { field: 'StatusDesc', title: '״̬', width: 130 }
             ]
         ]
     });
}




//��֤�绰���ƶ��绰
function CheckTelOrMobile(telephone,Name,Type){
	if (isMoveTel(telephone)) return true;
	if (telephone.indexOf('-')>=0){
		$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
			$("#"+Name).focus();
		});
        return false;
	}else{
		if(telephone.length!=11){
			$.messager.alert("��ʾ",Type+"��ϵ�绰�绰����ӦΪ��11��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			});
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�����ڸúŶε��ֻ���,���ʵ!","info",function(){
				$("#"+Name).focus();
			});
	        return false;
		}
	}
	return true;
}
/* 
��;����������Ƿ���ȷ�ĵ绰���ֻ��� 
���룺 �绰��
value���ַ��� 
���أ� ���ͨ����֤����true,���򷵻�false 
*/  
function isMoveTel(telephone){
 	
	var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
	var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
		return false; 
	}else{ 
		return true; 
	} 

}


function isIdCardNo(pId){
	pId=pId.toLowerCase();
    var arrVerifyCode = [1,0,"x",9,8,7,6,5,4,3,2]; 
    var Wi = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]; 
    var Checker = [1,9,8,7,6,5,4,3,2,1,1]; 
    if(pId.length != 15 && pId.length != 18){
		 $.messager.alert("��ʾ","���֤�Ź���15λ��18λ","info");
		return false;
    }
    var Ai=pId.length==18?pId.substring(0,17):pId.slice(0,6)+"19"+pId.slice(6,15); 
    
    if (!/^\d+$/.test(Ai))
    {
	     $.messager.alert("��ʾ","���֤�����һλ�����Ϊ����","info");
    	return false;
    }
    var yyyy=Ai.slice(6,10), mm=Ai.slice(10,12)-1, dd=Ai.slice(12,14);
    var d=new Date(yyyy,mm,dd) , now=new Date(); 
    var year=d.getFullYear() , mon=d.getMonth() , day=d.getDate();
    if (year!=yyyy||mon!=mm||day!=dd||d>now||year<1901){
	    $.messager.alert("��ʾ","���֤�������","info");
	    return false;
    }
	for(var i=0,ret=0;i<17;i++) ret+=Ai.charAt(i)*Wi[i]; 
	Ai+=arrVerifyCode[ret%=11];
	
	if (pId.length == 18){
		if(!validId18(pId)){
			 $.messager.alert("��ʾ","���֤��������,����!","info");
			return false;
		}
	}
	if (pId.length == 15){
		if(!validId15(pId)){
			 $.messager.alert("��ʾ","���֤��������,����!","info");
			return false;
		}
	}
	return true;
}



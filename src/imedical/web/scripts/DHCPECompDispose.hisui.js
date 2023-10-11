//����	DHCPECompDispose.hisui.js
//����	���Ͷ�ߴ���	
//����	2023.02.06
//������  ln

$(function(){
	 
	InitCombobox();
		
	//����
	$("#Save").click(function() {	
		Save_click();		
        });

	//����
	$("#Clear").click(function() {	
		Clear_click();		
        });
        	
    iniForm();   	
})

function Clear_click()
{
	$("#CompDetail,#Remark").val("");
	$(".hisui-combobox").combobox('setValue',"");
}

function InitCombobox()
{
	//����ʽ
   var CompModeObj = $HUI.combobox("#CompMode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=SearchByCode&ResultSetType=array&appcode="+"PEComplain"+"&Paramcode="+"CMode",
		valueField:'TypeValue',
		textField:'ParamValue'
		});
}

function iniForm()
{
	if (RowId=="")
	{
		$.messager.alert("��ʾ", "��ѡ��Ͷ�߼�¼", "info");
		return false;
	}
	var ComplainInfo=tkMakeServerCall("web.DHCPE.Complain","GetComplainContent",RowId);
	
	var ret=ComplainInfo.split("^");
	$("#CompContent").val(ret[0]);
	setValueById("CompMode",ret[1]);
	$("#CompDetail").val(ret[2]);
	$("#Remark").val(ret[3]);
	
}

function Save_click()
{
	var CompMode=$("#CompMode").combobox('getValue');
	if (CompMode==undefined) {var CompMode="";}
	
	var CompDetail=$("#CompDetail").val();
	var Remark=$("#Remark").val();
	
	var Instring=$.trim(RowId)			            //			    1 
				+"^"+$.trim(CompMode)			    //����ʽ		2
				+"^"+$.trim(CompDetail)			    //��������		3
				+"^"+$.trim(Remark)	                //��ע		    4
				;
				
	var ret=tkMakeServerCall("web.DHCPE.Complain","UpdateCompDispose",Instring);			
	if(ret.split("^")[0]==-1){
			$.messager.alert('��ʾ',"����ʧ��"+ret.split("^")[1],'error');
			return false;
		}
		else{
			$.messager.popover({msg: '���³ɹ���',type:'success',timeout: 1000});
			//Clear_click();
		}
}

function trim(s) {
	if (""==s) { return "";}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];
}
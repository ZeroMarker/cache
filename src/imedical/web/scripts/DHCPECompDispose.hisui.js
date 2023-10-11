//名称	DHCPECompDispose.hisui.js
//功能	体检投诉处理	
//创建	2023.02.06
//创建人  ln

$(function(){
	 
	InitCombobox();
		
	//保存
	$("#Save").click(function() {	
		Save_click();		
        });

	//清屏
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
	//处理方式
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
		$.messager.alert("提示", "请选择投诉记录", "info");
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
				+"^"+$.trim(CompMode)			    //处理方式		2
				+"^"+$.trim(CompDetail)			    //处理详情		3
				+"^"+$.trim(Remark)	                //备注		    4
				;
				
	var ret=tkMakeServerCall("web.DHCPE.Complain","UpdateCompDispose",Instring);			
	if(ret.split("^")[0]==-1){
			$.messager.alert('提示',"更新失败"+ret.split("^")[1],'error');
			return false;
		}
		else{
			$.messager.popover({msg: '更新成功！',type:'success',timeout: 1000});
			//Clear_click();
		}
}

function trim(s) {
	if (""==s) { return "";}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];
}
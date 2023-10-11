
//����	dhcpe/ct/dhcpeinpatienttohp.indoc.hisui.js
//����	סԺҽ��ά�� ��Ժ��
//����	2021.08.12
//������  sxt
var tableName = "DHC_PE_OthPatToHPBase";

var DetailtableName = "DHC_PE_OthPatToHPBaseCPT";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	GetLocComp(SessionStr);
		
	InitCombobox();
	
	InitIPToHPInDocDataGrid();
      
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
    //����
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
        
    //ɾ��
	$("#BDelete").click(function() {	
		BDelete_click();		
       });
    	
	 //���������б�change
	$("#LocList").combobox({
       onSelect:function(){
	       BClear_click();		 
       }
		
	});
})



//����
function BClear_click()
{
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];

	$("#UserName").combogrid('setValue',"");
	$("#ID").val("");
	var valbox = $HUI.combogrid("#UserName", {
				required: false,
	   	   });
	$("#IPToHPInDocQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindInDoc",
			curLoc:locId
		});
}

 //����
 function BAdd_click()
 {
	var globalLoc = $("#LocList").combobox("getValue");
	var LocID = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];

	//LocID=session['LOGON.CTLOCID'];
	
	var UserID=$("#ID").val();
	if($("#ID").val()!=""){
			$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    return false;
	}
	if(UserID==""){
		var UserID=$("#UserName").combogrid('getValue');
        if (($("#UserName").combogrid('getValue')==undefined)||($("#UserName").combogrid('getValue')=="")){var UserID="";}
	}
	
	if (UserID!=""){
			var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","IsUser",UserID);
			if(flag=="0"){
				$.messager.alert("��ʾ","��ѡ��ҽ��","info");
				return false;
				}
			
	}else{
		    $("#UserName").focus();
		    $.messager.alert("��ʾ","ҽ������Ϊ��","info");
		 	var valbox = $HUI.combogrid("#UserName", {
				required: true,
	   	   });
			return false;
		}
	
	//alert(LocID+"^"+UserID)
	var ret=tkMakeServerCall("web.DHCPE.CT.OtherPatientToHPBaseSet","SetInDoc",LocID,UserID,"N");
	
	 BClear_click();
	 if(ret==0){
		$.messager.alert("��ʾ","�����ɹ�","success");
	  }
				
 
 }

 //ɾ��
function BDelete_click()
{
	LocID=session['LOGON.CTLOCID'];
	var UserID=$("#ID").val();
	
	if (UserID==""){
		$.messager.alert("��ʾ","��ѡ���ɾ��������","info");
		return false;
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet", MethodName:"SetInDoc",LocID:LocID,UserID:UserID,DeleteFlag:"Y"},function(ReturnValue){
				if (ReturnValue!="0") {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");
				}else{
					BClear_click();
					$.messager.alert("��ʾ","ɾ���ɹ�","success");
				}
				});
		}
	});
	
}


function InitCombobox()
{
	//����Ա
	   var OPNameObj = $HUI.combogrid("#UserName",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindCTPCP",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:40},
			{field:'DocName',title:'����',width:200},
			{field:'Initials',title:'����',width:200}			
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',"")	
		}
		});
}

function InitIPToHPInDocDataGrid()
{
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	$HUI.datagrid("#IPToHPInDocQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindInDoc",
			curLoc:locId
		},
		columns:[[
	
		    {field:'UserID',title:'UserID',hidden: true},
			{field:'UserCode',width:'600',title:'����'},
			{field:'UserName',width:'600',title:'ҽ��'}
		
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#ID").val(rowData.UserID);
				$("#UserName").combogrid('setValue',rowData.UserName);		
				
			
		}
		
			
	})

}



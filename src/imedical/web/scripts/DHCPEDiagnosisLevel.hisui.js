
//����	DHCPEDiagnosisLevel.hisui.js
//����	���鼶��ά��	
//����	2019.05.17
//������  xy

$(function(){
	

	InitDiagnosisLevelDataGrid();
	
	
     //����
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
        
    //�޸�
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
     
     //ɾ��
	$("#BDelete").click(function() {	
		BDelete_click();		
        });
        
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
	  info();
})

function info()
{
	
	var ID=$("#ID").val()
	if(ID==""){
		$("#BAdd").linkbutton('enable');
		$("#BUpdate").linkbutton('disable');
		$("#BDelete").linkbutton('disable');
	}else{
		$("#BAdd").linkbutton('disable');
		$("#BUpdate").linkbutton('enable');
		$("#BDelete").linkbutton('enable');
	}
	
}



//�޸�
function BUpdate_click()
{
	BSave_click("1");
}

 //����
function BAdd_click()
{
	BSave_click("0");
}

//����
function BSave_click(Type)
{
	var ID=$("#ID").val();
	
	if(Type=="1"){
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	if(Type=="0"){
		if(ID!=""){
			$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,��������������","info");
			return false;
		}
	}
	
	var iLevel=$.trim($("#Level").val());
	if (""==iLevel) {
	    
		$.messager.alert("��ʾ","������Ϊ��","info",function(){
		var valbox = $HUI.validatebox("#Level", {
			required: true,
	   	});
			$("#Level").focus();
		});
		return false;

	 }
	 
	var iDesc=$.trim($("#Desc").val());
     if (""==iDesc) {
		$.messager.alert("��ʾ","��������Ϊ��","info",function(){
			var valbox = $HUI.validatebox("#Desc", {
			required: true,
	   	});
			$("#Desc").focus();
		});
		return false;

	 }

	var iWarnFlag="N"

    if(Type==0){
		var Instring=iLevel+"^"+iDesc+"^"+iWarnFlag;
		var flag=tkMakeServerCall("web.DHCPE.DiagnosisLevel","Insert",'','',Instring);
    }else{
	    var Instring=ID+"^"+iLevel+"^"+iDesc+"^"+iWarnFlag;
		var flag=tkMakeServerCall("web.DHCPE.DiagnosisLevel","Update",'','',Instring);
    }
	   var flag=flag.split("^")
	if (flag[0]==0){
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}
		BClear_click(); 
	
	}else if (flag[0]=="-1"){
		$.messager.alert("��ʾ",flag[1],"info");
	
	}else{
		if(Type=="0"){$.messager.alert("��ʾ","�޸Ĵ���","error");}
		if(Type=="1"){$.messager.alert("��ʾ","��������","error");}
			
	} 


}

function BDelete_click()
{
	var ID=$("#ID").val();
	if(ID==""){
			$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
			return false;
	}
	
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.DiagnosisLevel", MethodName:"Delete",InString:ID},function(ReturnValue){
				if (ReturnValue!="0") {
					if(ReturnValue.indexOf("^")>0){
						$.messager.alert("��ʾ","ɾ��ʧ��:"+ReturnValue.split("^")[1],"error"); 
					} else{
						$.messager.alert("��ʾ","ɾ��ʧ��","error"); 
					}
 
				}else{
					$.messager.alert("��ʾ","ɾ���ɹ�","success");
					BClear_click();	
				}
				});
		}
	});
	
	
}

//����
function BClear_click()
{
	$("#Level,#Desc,#ID").val("");
	var valbox = $HUI.validatebox("#Level,#Desc", {
		required: false,
	  });
	  $("#DiagnosisLevelQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.DiagnosisLevel",
			QueryName:"LevelAll",
		
			});
	info();
	
}


function InitDiagnosisLevelDataGrid(){
		$HUI.datagrid("#DiagnosisLevelQueryTab",{
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
			ClassName:"web.DHCPE.DiagnosisLevel",
			QueryName:"LevelAll",
		
		},
		columns:[[
		    {field:'TRowID',title:'ID',hidden: true},
			{field:'TLevel',width:'400',title:'����'},
			{field:'TDesc',width:'760',title:'����'},
			
					
		]],
		onSelect: function (rowIndex, rowData) {
				$("#ID").val(rowData.TRowID);
				$("#Level").val(rowData.TLevel);
				$("#Desc").val(rowData.TDesc);
				$("#BAdd").linkbutton('disable');
				$("#BUpdate").linkbutton('enable');
				$("#BDelete").linkbutton('enable');


		}
			
	})

		
}


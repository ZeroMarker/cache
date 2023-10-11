
//����	DHCPEPreGADM.Home.hisui.js
//����	��������
//����	2020.12.29
//������  xy
$(function(){
	 
	InitPreGADMHomeDataGrid();
	
	//����
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
   //ɾ��
     $("#BDelete").click(function() {	
		BDelete_click();		
        });
     
      
     //����
     $("#BUpdate").click(function() {	
		BUpdate_click();		
        });
       
})


function BUpdate_click(){
	if(PGADMDr==""){
		return false;
		}
	
	var DrId=PGADMDr+"^"+Type;
	var iRemark=$("#Remark").val();
	var RowId=$("#RowId").val();
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	if(BeginDate == "" || BeginDate == null
		|| EndDate == "" || EndDate == null){
		$.messager.alert("��ʾ","��ʼ�������������Ϊ�����","info");
		return false;
	}
	var BeginDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",BeginDate);
	var EndDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",EndDate);
	if(Type=="C"){
		var value=tkMakeServerCall("web.DHCPE.Contract","GetInfoByID",PGADMDr);
		var SighDate=value.split("^")[3];
		 if(SighDate!=""){var SighDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",SighDate);}
		 if(BeginDateLogical<SighDate){
			$.messager.alert("��ʾ","��ʼ���ڲ���С�ں�ͬǩ������","info");
			return false;
		}
   }

    if(EndDateLogical<SighDate){
	   $.messager.alert("��ʾ","�������ڲ���С�ں�ͬǩ������","info");
	    return false;
   }
	var Num=$("#Num").val();
	if(Num.indexOf("-")<=-1){
		$.messager.alert("��ʾ","ÿ��������ʽӦΪ��ÿ������(��)-ÿ������(Ů)��:���硰10-10��","info");
	    return false;
	    }

	if(Num.indexOf("-")>=0)
	   {
		   
		   var Data=Num.split("-");
			if((Data[0]=="")||(Data[1]=="")){
			    $.messager.alert("��ʾ","ÿ������-ǰ��ӦΪ����","info");
			    return false;
		   }
		   
		   var reg = /^[0-9]+.?[0-9]*$/; 
		   if(!(reg.test(Data[1]))||!(reg.test(Data[0]))) 
		   {
			   $.messager.alert("��ʾ","ÿ������-ǰ��ӦΪ����","info");
			    return false; 
		   }
	   }

	if(Num == "" || Num == null || Num == undefined || Num == "-"){
		$.messager.alert("��ʾ","��������Ϊ�գ�","info");
		return false;
	}
	
     
     //alert(DrId+"^"+RowId+"^"+BeginDate+"^"+EndDate+"^"+Num+"^"+iRemark)
	var rnt =tkMakeServerCall("web.DHCPE.PreHome","UpdateMethod",DrId,RowId,BeginDate,EndDate,Num,iRemark)
	if(rnt == "1"){	
		$.messager.alert("��ʾ","�����е������������ص�������ʧ�ܣ�","info");
	} else if(rnt == "2"){
		$.messager.alert("��ʾ","���������󣬸���ʧ�ܣ�","info");
	} else if (rnt == "4"){
		$.messager.alert("��ʾ","��ʼ���ڲ������ڽ������ڣ�����ʧ�ܣ�","info");
	}else if (rnt == "5"){
		$.messager.alert("��ʾ","�������ڲ��ܴ��������ԤԼʱ�䣬����ʧ�ܣ�","info");
	}else if (rnt == "8"){
		$.messager.alert("��ʾ","��ʼ���ڲ���С�������ԤԼʱ�䣬����ʧ�ܣ�","info");
	}else if (rnt == "6"){
		$.messager.alert("��ʾ","������������С���������Գ�Ա����������ʧ�ܣ�","info");
	}else if (rnt == "7"){
		$.messager.alert("��ʾ","����Ů������С������Ů�Գ�Ա����������ʧ�ܣ�","info");
	}else if (rnt == "3"){
		$.messager.alert("��ʾ","���³ɹ�","success");
		
		BClear_click();
		
		$("#PreGADMHomeGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreHome",
			QueryName:"SerchHomeInfo",
			PGADMDr:PGADMDr,
			Type:"G"
		})
		
	} 
}

function BDelete_click(){
	var RowId=$("#RowId").val();
	if(RowId == null || RowId=="" || RowId==undefined){
		$.messager.alert("��ʾ","��ѡ���ɾ��������","info");
		return false;	
	}
	
	
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.PreHome", MethodName:"DeleteMethod",RowId:RowId},function(ReturnValue){
				if (ReturnValue=='1') {
					$.messager.alert("��ʾ","���ݲ����ڣ�ɾ��ʧ��","error");  
				}else if((ReturnValue=='2')){
					$.messager.alert("��ʾ","����������ɾ��ʧ��","error"); 
				}else if((ReturnValue=='3')){
					$.messager.alert("��ʾ","ɾ���ɹ�","success"); 
					 
					 $("#PreGADMHomeGrid").datagrid('load',{
						ClassName:"web.DHCPE.PreHome",
						QueryName:"SerchHomeInfo",
						PGADMDr:PGADMDr,
						Type:"G"
					})
					
					  BClear_click()
					
				}
			});	
		}
	});
	
}

function BClear_click()
{
	$("#RowId").val("");
	$("#BeginDate").datebox('setValue',"")
	$("#EndDate").datebox('setValue',"");
	$("#Num,#Remark").val("");
}


//ʱ����Ϣ����
function BTimeLink(rowIndex)
{
	 var rowobj=$('#PreGADMHomeGrid').datagrid('getRows')[rowIndex];
	 var HomeRowID=rowobj.THomeRowID;
	 var PreGADM=rowobj.TPADMDr;
	 
	$HUI.window("#PreTemplateTimeWin", {
        title: "ԤԼʱ��",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: true,
        resizable: true,
        closable: true,
        modal: true,
        width: 600,
        height: 600,
        content: '<iframe src="dhcpepretemplatetime.hisui.csp?ParRef=' + HomeRowID + '&Type=H'+"&PreGADM="+PreGADM+'" width="100%" height="100%" frameborder="0"></iframe>'
    });
	
}
function InitPreGADMHomeDataGrid()
{
	$HUI.datagrid("#PreGADMHomeGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		
		queryParams:{
			ClassName:"web.DHCPE.PreHome",
			QueryName:"SerchHomeInfo",
			PGADMDr:PGADMDr,
			Type:"G"
				
		},
		columns:[[
			{field:'THomeRowID',title:'HomeRowID',hidden: true},
			{field:'TPADMDr',title:'PADMDr',hidden: true},
		    {field:'TMaleNum',width:'150',title:'ÿ������(��)'},
			{field:'TFemaleNum',width:'150',title:'ÿ������(Ů)'},
			{field:'TTimeLink',width:'180',title:'ʱ����Ϣ',align:'center',
			formatter:function(value,rowData,rowIndex){	
				if(rowData.THomeRowID!=""){
			            return '<a><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  title="ʱ����Ϣ" border="0" onclick="BTimeLink('+rowIndex+'\)"></a>';
					}
					
			}},
			{field:'TDate',width:'150',title:'����'},
			{field:'TRemark',width:'300',title:'��ע'}			
		]],
		onSelect: function (rowIndex, rowData) {
			
			$("#RowId").val(rowData.THomeRowID);
			$("#BeginDate").datebox('setValue',rowData.TDate);
			$("#EndDate").datebox('setValue',rowData.TDate);
			$("#Num").val(rowData.TMaleNum+"-"+rowData.TFemaleNum);
			$("#Remark").val(rowData.TRemark)
	   	
					
		}
			
	})
}
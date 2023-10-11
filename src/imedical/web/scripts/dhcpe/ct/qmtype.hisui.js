
//����	dhcpe/ct/qmtype.hisui.js
//����	��������������� dyq	
//����	2021.08.15
//������  sxt
var lastIndex = "";
var EditIndex = -1;
var tableName = "DHC_PE_QMType";
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	GetLocComp(SessionStr);

	InitQMTypeDataGrid();
	
	//�޸�
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
     //����
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
        
    //����
	$("#BClear").click(function() {	
		BClear_click(0);		
        });
    
    /// ��������
    $("#RelateLoc").click(function() {	
		BRelateLoc_click();		
        });
      
       
    /// �л�����ˢ������
	$("#LocList").combobox({
	     onSelect:function(data){  
		   		var CurLoc=$("#LocList").combobox('getValue');
		   		if(CurLoc==undefined) CurLoc=session['LOGON.CTLOCID'];
		   		$("#QMTypeQueryTab").datagrid('load',{
						ClassName:"web.DHCPE.CT.QualityManager",
						QueryName:"SearchQMTypeNew",
						LocID:CurLoc
				});		    
		 }
     })
     
    
    
    //��ť����Ȩ�ޣ��ܿ����ݣ�
    DisableButton();
     
})


//��ť����Ȩ�ޣ��ܿ����ݣ�
function DisableButton(){
    var UserID=session['LOGON.USERID'];
    var GroupID=session['LOGON.GROUPID'];
    var flag = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetUserPower",UserID,GroupID);
    if(flag=="S"){
        $('#RelateLoc').linkbutton('enable');
        $("#BUpdate").linkbutton('enable');
        $("#BAdd").linkbutton('enable');    
    }else{
        $('#RelateLoc').linkbutton('disable');
        $("#BUpdate").linkbutton('disable');
        $("#BAdd").linkbutton('disable');
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
	
	var Code=$("#Code").val();
	var Desc=$("#Desc").val();
	var Remark=$("#Remark").val();
	var ExpStr=$("#ExpStr").val();
	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	if(Type=="0"){
		
		if($("#ID").val()!=""){
			$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,��������������","info");
			return false;
		}
		var ID="";
	}

	var iActiveFlag="N";
	var ActiveFlag=$("#ActiveFlag").checkbox('getValue');
	if(ActiveFlag) iActiveFlag="Y";
   
    if (""==Code) {
	    
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	  });
		$.messager.alert("������ʾ","���벻��Ϊ��","error");
		return false;
	 }
	 
      if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	   });
	   
		$.messager.alert("������ʾ","�������Ͳ���Ϊ��","error");
		return false;
	 }

	if (""==ExpStr) {
		$("#ExpStr").focus();
		var valbox = $HUI.validatebox("#ExpStr", {
			required: true,
	    });
		$.messager.alert("������ʾ","��չ��Ϣ����Ϊ��","error");
		return false;
	 }

	var SaveInfo=Code+"^"+Desc+"^"+Remark+"^"+ExpStr+"^"+iActiveFlag;
	var Ret=tkMakeServerCall("web.DHCPE.CT.QualityManager","SaveQMType",ID,SaveInfo,session['LOGON.USERID']);
	var Arr=Ret.split("^");
	if (Arr[0]=="0"){
		$.messager.popover({msg: Arr[1],type:'success',timeout: 1000});
		BClear_click(1);
		$("#QMTypeQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.QualityManager",
			QueryName:"SearchQMTypeNew",
			LocID:$("#LocList").combobox('getValue')
			});
	
	}else{
		$.messager.alert("��ʾ",Arr[1],"error");
		
	} 

}
//���ݹ�������
function BRelateLoc_click()
{	
	var DateID=$("#ID").val()
	if (DateID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
		return false;
	}   

   var LocID=$("#LocList").combobox('getValue');
   OpenLocWin(tableName,DateID,SessionStr,LocID,InitQMTypeDataGrid);
 }

//����
function BClear_click(Type)
{
	$("#Code,#Desc,#ExpStr,#Remark,#ID").val("");

	$("#ActiveFlag").checkbox('setValue',true);

	var valbox = $HUI.validatebox("#Code,#Desc,#ExpStr", {
		required: false,
	  });

	if(Type=="0"){
		$("#LocList").combobox('setValue',session["LOGON.CTLOCID"]);
	}
	
   
    var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];

	$('#QMTypeQueryTab').datagrid('load', {
			ClassName:"web.DHCPE.CT.QualityManager",
			QueryName:"SearchQMTypeNew", 
			LocID:locId
		});
}


function InitQMTypeDataGrid(){

	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	$HUI.datagrid("#QMTypeQueryTab",{
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
			ClassName:"web.DHCPE.CT.QualityManager",
			QueryName:"SearchQMTypeNew",
			LocID:locId
		},
		columns:[[
	
		    {field:'ID',title:'ID',hidden: true},
			{field:'Code',width:'100',title:'����'},
			{field:'Desc',width:'230',title:'��������'},
			{field:'ActiveFlag',width:'50',title:'����',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="��"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                   }
			},
			{field:'Remark',width:'150',title:'��ע'},
			{field:'ExpStr',width:'200',title:'��չ��Ϣ'},
			{ field:'TEffPowerFlag',width:100,align:'center',title:'��ǰ������Ȩ',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			}
		]],
		onSelect: function (rowIndex, rowData) {
				var Code=$("#Code").val(rowData.Code);
				var Desc=$("#Desc").val(rowData.Desc);
				var Remark=$("#Remark").val(rowData.Remark);
				var ExpStr=$("#ExpStr").val(rowData.ExpStr);
				var ID=$("#ID").val(rowData.ID);
				
				if(rowData.ActiveFlag=="��"){
					$("#ActiveFlag").checkbox('setValue',false);
				}if(rowData.ActiveFlag=="��"){
					$("#ActiveFlag").checkbox('setValue',true);
				}


		}
			
	})

		
}


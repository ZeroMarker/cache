
//����	dhcpe/ct/inpatienttohp.recloc.hisui.js
//����	����ѽ��տ������� -��Ժ��
//����	2021.08.11
//������  sxt
var lastIndex = "";
var EditIndex = -1;
var tableName = "DHC_PE_OthPatToHPBase";
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
		
	GetLocComp(SessionStr);
	
	InitCombobox();
	
	InitIPToHPRecLocDataGrid();
    
    //����
    $("#BClear").click(function() {	
		BClear_click();		
        }); 
    
    //���տ���
	$("#BSaveRecLoc").click(function() {	
		BSaveRecLoc_click();		
        });
        
	$("#LocList").combobox({
		onSelect: function(rowData)
		{
			$("#IPToHPRecLocQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindStation",
			curLoc:$("#LocList").combobox('getValue')
		});	
		}
		
	})
   
   
})

//����
function BClear_click(){
	$("#ID,#HPBID,#StationDesc").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$(".hisui-combogrid").combogrid('setValue',"");
	$("#IPToHPRecLocQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindStation",
			curLoc: $("#LocList").combobox("getValue")
			
	});	
}

//���տ���
function BSaveRecLoc_click()
{
	var LocID=$("#LocList").combobox('getValue'); //session['LOGON.CTLOCID'];
	var StationID=$("#ID").val();
	if (StationID==""){
		$.messager.alert("��ʾ","��ѡ��վ�㣬Ȼ�󱣴�����","info");
		return false;
	}
	var RecLocID=$("#RecLocDesc").combogrid('getValue');
	//alert(RecLocID)
	if (($("#RecLocDesc").combogrid('getValue')==undefined)||($("#RecLocDesc").combogrid('getValue')=="")){var RecLocID="";}

	var DefaultDocID=$("#DefaultDoc").combogrid('getValue');
	if (($("#DefaultDoc").combogrid('getValue')==undefined)||($("#DefaultDoc").combogrid('getValue')=="")){var DefaultDocID="";}
      
     var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(RecLocID)))&&(RecLocID!="")){var RecLocID=$("#RecLocID").val();}
    if((!(reg.test(DefaultDocID)))&&(DefaultDocID!="")){var DefaultDocID=$("#DefaultDocID").val();}
	//alert(RecLocID+"^"+DefaultDocID)

	var StationHPBID=$("#HPBID").val();
	
	var EmpowerFlag="N";
	if($("#Empower").checkbox('getValue')) EmpowerFlag="Y";
	
	var ActiveFlag="N";
	if($("#Active").checkbox('getValue')) ActiveFlag="Y";
	
	var ret=tkMakeServerCall("web.DHCPE.CT.OtherPatientToHPBaseSet","SetStationConRecLoc",LocID,StationID,RecLocID,StationHPBID,DefaultDocID,ActiveFlag);
	
	var arr=ret.split("^");
	if(arr[0]!="-1"){
	$("#IPToHPRecLocQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindStation",
			curLoc:$("#LocList").combobox('getValue')
		});
		$.messager.popover({msg: '���տ������óɹ�',type:'success',timeout: 1000});
	}else{
		$.messager.alert("��ʾ",+arr[1],"error");	
	}
}
 
 
function InitCombobox()
{
	  
	 //Ĭ��ҽ��
	 var OPNameObj = $HUI.combogrid("#DefaultDoc",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
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
		    {field:'DocDr',title:'ID',width:50},
			{field:'DocName',title:'����',width:200},
			{field:'Initials',title:'����',width:190} 
				
		]]

		});

	//���տ���
	var OPNameObj = $HUI.combogrid("#RecLocDesc",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest",
		mode:'remote',
		delay:200,
		idField:'CTLOCID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ctlocdesc= param.q;
			param.hospId = session['LOGON.HOSPID'];
		},
		columns:[[
		    {field:'CTLOCID',title:'ID',width:40},
		    {field:'Desc',title:'����',width:200},
			{field:'CTLOCCODE',title:'����',width:200},
				
		]]
		});
		
}

function InitIPToHPRecLocDataGrid()
{
	//alert(212)
	$HUI.datagrid("#IPToHPRecLocQueryTab",{
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
			QueryName:"FindStation",
			curLoc:session['LOGON.CTLOCID']
		},
		columns:[[
	
		    {field:'StationID',title:'StationID',hidden: true},
			{field:'ReclocID',title:'StationID',hidden: true},
		    {field:'UserID',title:'StationID',hidden: true},
			{field:'StationDesc',width:'300',title:'վ������'},
			{field:'RecLocDesc',width:'400',title:'���տ���'},
			{field:'DefaultDoc',width:'300',title:'Ĭ��ҽ��'},
			{field:'TActiveFlag',width:'150',title:'�Ƿ���Ч',align:'center',
				formatter: function (value, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                  }
			}	
		
		]],
		onSelect: function (rowIndex, rowData) {
			    //debugger; 
			    //alert(2)
				$("#ID").val(rowData.StationID);
				//$("#RecLocID").val(rowData.ReclocID);
				$("#StationDesc").val(rowData.StationDesc);
				$("#RecLocDesc").combogrid("grid").datagrid("reload",{"q":rowData.RecLocDesc});
				$("#RecLocDesc").combogrid('setValue',rowData.ReclocID);
				$("#DefaultDoc").combogrid("grid").datagrid("reload",{"q":rowData.DefaultDoc});
				$("#DefaultDoc").combogrid('setValue',rowData.UserID);
				//$("#GenConUser").combogrid('setValue',rowData.GenConUserDesc); 
				
				$("#HPBID").val(rowData.HPBID); //���һ����
				if(rowData.TActiveFlag=="Y"){
					$("#Active").checkbox('setValue',true);
				}
				else{
					$("#Active").checkbox('setValue',false);
					}
					
		}
		
			
	})

}



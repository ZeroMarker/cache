
//����    dhcpeillsalias.js
//����    ��������ά��-��Ժ��
//����    2021-08-14
//������  yupeng
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
var tableName = "DHC_PE_ILLSAlias";
var UserID=session['LOGON.USERID'];

$(function(){
     
        
    //��ȡ�����б�
    GetLocComp(SessionStr,SelectLocID)  
      
    $("#ILLSName").val(selectrowDesc);
    
    InitILLSAliasDataGrid();
      
    //����
    $('#add_btn').click(function(e){
        AddData();
    });
    
    //�޸�
    $('#update_btn').click(function(){
        UpdateData();
    });
    
    //ɾ��
    $('#del_btn ').click(function(){
        DelData();
    });
    
    //������Ȩ
	$("#BPower").click(function(){
    	BPower_click();
	})
	
    //���ݹ�������
    $("#BRelateLoc").click(function() { 
        BRelateLoc_click();     
     }); 
     
    //���������б�change
	$("#LocList").combobox({
       onSelect:function(){
	     InitILLSAliasDataGrid();  
	    		 
       }
		
	});
     
})


//������Ȩ/ȡ����Ȩ
function BPower_click(){
	var DateID=$("#AliasRowId").val()
	if (DateID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ������Ȩ�ļ�¼","info"); 
		return false;
	}
	var selected = $('#ILLSAliasGrid').datagrid('getSelected');
	if(selected){
	
		//������Ȩ 
	    var iEmpower=$.trim($("#BPower").text());
	    if(iEmpower==$g("������Ȩ")){var iEmpower="Y";}
	    else if(iEmpower==$g("ȡ����Ȩ")){var iEmpower="N";}
		var LocID=$("#LocList").combobox('getValue');
		var UserID=session['LOGON.USERID'];
		alert(tableName+"^"+DateID+"^"+LocID+"^"+UserID+"^"+iEmpower)
	    var rtn=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","SaveDataToPowerControl",tableName,DateID,LocID,UserID,iEmpower)
		var rtnArr=rtn.split("^");
		if(rtnArr[0]=="-1"){
			$.messager.alert("��ʾ","��Ȩʧ��","error");
		}else{
			$.messager.popover({msg:'��Ȩ�ɹ�',type:'success',timeout: 1000});
			 $("#ILLSAliasGrid").datagrid('reload');
		}		
	}	
}
    
    
    
//���ݹ�������
function BRelateLoc_click()
{
    var DataID=$("#AliasRowId").val()
    if (DataID==""){
        $.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
        return false;
    }
   //var UserID=session['LOGON.USERID'];

   var LocID=$("#LocList").combobox('getValue')
   
   OpenLocWin(tableName,DataID,SessionStr,LocID,InitILLSAliasDataGrid)
}

function LoadILLSAlias()
{
     $("#ILLSAliasGrid").datagrid('reload');
}


//����
function AddData(){
    Update("0");
}

//�޸�
function UpdateData(){
    Update("2");
}

//ɾ��
function DelData(){
    Update("1");
}

function Update(Type){
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
    var ID=$("#AliasRowId").val();
    if((Type=="1")&&(ID=="")){
         $.messager.alert('��ʾ','��ѡ���ɾ���ļ�¼',"info");
         return false;
    }
    if((Type=="2")&&(ID=="")){
         $.messager.alert('��ʾ','��ѡ����޸ĵļ�¼',"info");
         return false;
    }
    if(Type=="0"){var ID="";}
    var EDId=selectrow;
    var Alias=$("#Alias").val();
    if (Alias=="")
    {
        $.messager.alert('��ʾ','��������Ϊ��',"info");
         return false;
    }
    
   var DataStr=ID+"^"+EDId+"^"+Alias;
   var flag=tkMakeServerCall("web.DHCPE.CT.IllnessStandard","UpdateAlias",DataStr,Type,tableName,UserID,$("#LocList").combobox('getValue'));
   if (flag==0)
    {
        if(Type=="2"){$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});}
        if(Type=="0"){$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});}
        if(Type=="1"){$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});}
        $("#AliasRowId,#Alias").val("");
        $("#ILLSAliasGrid").datagrid('load',{
            ClassName:"web.DHCPE.CT.IllnessStandard",
            QueryName:"FindIllAlias",
            ILLSRowID:selectrow,
            tableName:tableName, 
            LocID:locId   
        }); 
    }else{
        $.messager.alert('��ʾ',"����ʧ��","error");
    } 

}

function InitILLSAliasDataGrid(){
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
    $HUI.datagrid("#ILLSAliasGrid",{
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
            ClassName:"web.DHCPE.CT.IllnessStandard",
            QueryName:"FindIllAlias",
            ILLSRowID:selectrow,
            tableName:tableName, 
            LocID:locId     
        },
        columns:[[
            {field:'id',title:'ID',hidden: true},
            {field:'desc',width:250,title:'����'},
            {field:'TEmpower',width:150,title:'������Ȩ',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			
			},
			{ field:'TEffPowerFlag',width:150,align:'center',title:'��ǰ������Ȩ',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			},
        
        ]],
        onSelect: function (rowIndex, rowData) {
               
                $("#AliasRowId").val(rowData.id);
                $("#Alias").val(rowData.desc); 
                if(rowData.TEmpower=="Y"){	
					$("#BRelateLoc").linkbutton('enable');
					$("#BPower").linkbutton({text:$g('ȡ����Ȩ')});
				}else{
					$("#BRelateLoc").linkbutton('disable');
					$("#BPower").linkbutton('enable');
					$("#BPower").linkbutton({text:$g('������Ȩ')})
				
				}          
        }   
            
    })
}
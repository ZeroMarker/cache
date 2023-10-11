
//����    dhcpeillexplain.js
//����    ��������ά��-��Ժ��
//����    2021-08-14
//������  yupeng
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

var tableName = "DHC_PE_ILLSExplain";

var title="��������"
if(Type=="2"){ 
    tableName = "DHC_PE_ILLSSportGuide";
}
if(Type=="3"){ 
    tableName = "DHC_PE_ILLSDietGuide";
}

var UserID=session['LOGON.USERID'];

$(function(){
             
    //��ȡ�����б�
    GetLocComp(SessionStr,SelectLocID);
	
    $("#ILLSName").val(selectrowDesc);
    
    if(Type=="1"){ 
    
        title="��������"
        document.getElementById("TIllExplain").innerHTML=$g("��������");
    }
    if(Type=="2"){ 
        title="�˶�ָ��"
        document.getElementById("TIllExplain").innerHTML=$g("�˶�ָ��");
    }
    if(Type=="3"){ 
        title="��ʳָ��"
        document.getElementById("TIllExplain").innerHTML=$g("��ʳָ��");
    }   
    
    InitILLExplainDataGrid();
      
    //����
    $('#add_btn').click(function(e){
        AddData();
    });
    
    //�޸�
    $('#update_btn').click(function(){
        UpdateData();
    });

    //���ݹ�������
    $("#BRelateLoc").click(function() { 
        BRelateLoc_click();     
     });

	  //���������б�change
	$("#LocList").combobox({
 		onSelect:function(){
		 $("#ILLExplainGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.IllnessStandard",
            QueryName:"FindIllExplain",
            ILLSRowID:selectrow, 
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:$("#LocList").combobox('getValue'),
            Type:Type
        });       	    		 
  	}
  });
     
})


//���ݹ�������
function BRelateLoc_click()
{
    var DataID=$("#ExplainRowId").val()
    if (DataID==""){
        $.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
        return false;
    }
   
   var LocID=$("#LocList").combobox('getValue')
   
   OpenLocWin(tableName,DataID,SessionStr,LocID,InitILLExplainDataGrid)

   LoadIllExplain()
}

function LoadIllExplain()
{
     $("#ILLExplainGrid").datagrid('reload');
     $("#BRelateLoc").linkbutton('disable');
}

//����
function AddData(){
    Update("0");
}

//�޸�
function UpdateData(){
    Update("2");
}


function Update(UpdateType){
    var ID=$("#ExplainRowId").val();
    
    if((UpdateType=="2")&&(ID=="")){
         $.messager.alert('��ʾ','��ѡ����޸ĵļ�¼',"info");
         return false;
    }
    if(UpdateType=="0"){var ID="";}
    var EDId=selectrow;
    var IllExplain=$("#IllExplain").val();
	var IllExplain=IllExplain.replace(new RegExp(" ","g"),"");
    if (IllExplain=="")
    {
        if((Type=="1")){
	        $.messager.alert('��ʾ','�������Ͳ���Ϊ��',"info");
         	return false;
        }
        if((Type=="2")){
	        $.messager.alert('��ʾ','�˶�ָ������Ϊ��',"info");
         	return false;
        }
        if((Type=="3")){
	        $.messager.alert('��ʾ','��ʳָ������Ϊ��',"info");
         	return false;
        }

    }
    
    var NoActiveFlag=$("#NoActive").checkbox('getValue') ? "Y" : "N";
    var EmpowerFlag=$("#Empower").checkbox('getValue') ? "Y" : "N";
       
    var DataStr=ID+"^"+EDId+"^"+IllExplain+"^"+NoActiveFlag;
    var Return=tkMakeServerCall("web.DHCPE.CT.IllnessStandard","UpdateExplain",DataStr,tableName,UserID,$("#LocList").combobox('getValue'),EmpowerFlag,Type);
    var flag=Return.split("^")[0]
    if (flag==0)
        {
        if(UpdateType=="2"){$.messager.popover({msg:'�޸ĳɹ�',type:'success',timeout: 1000});}
        if(UpdateType=="0"){$.messager.popover({msg:'�����ɹ�',type:'success',timeout: 1000});}
        $("#ExplainRowId,#IllExplain").val("");
        $("#ILLExplainGrid").datagrid('load',{
            ClassName:"web.DHCPE.CT.IllnessStandard",
            QueryName:"FindIllExplain",
            ILLSRowID:selectrow, 
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:$("#LocList").combobox('getValue'),
            Type:Type
        }); 
    }else{
        $.messager.alert('��ʾ',"����ʧ��","error");
    }
    

}

function InitILLExplainDataGrid(){
    var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
    $HUI.datagrid("#ILLExplainGrid",{
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
            QueryName:"FindIllExplain",
            ILLSRowID:selectrow, 
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:LocID,
            Type:Type
            
        },
        columns:[[
            {field:'TRowID',title:'ID',hidden: true},
            {field:'Explain',width:'300',title:title},
            {field:'TNoActive',width:'40',title:'����',align:'center',
            	formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    }
            },
            {field:'TEmpower',width:'70',title:'������Ȩ',align:'center',
            	formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    }
			},{ field:'TEffPowerFlag',width:100,align:'center',title:'��ǰ������Ȩ',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			},
            {field:'TUpdateDate',width:'100',title:'��������'},
            {field:'TUpdateTime',width:'100',title:'����ʱ��'},
            {field:'TUserName',width:'100',title:'������'}
        ]],
        onSelect: function (rowIndex, rowData) {
               
                $("#ExplainRowId").val(rowData.TRowID);
                $("#IllExplain").val(rowData.Explain);
                if(rowData.TNoActive=="Y"){
	                $("#NoActive").checkbox('setValue',true);
                }else{
	                $("#NoActive").checkbox('setValue',false);
                }
                if(rowData.TEmpower=="Y"){		
					$("#BRelateLoc").linkbutton('enable');
					$("#Empower").checkbox('setValue',true);
				}else{
					$("#BRelateLoc").linkbutton('disable');
					$("#Empower").checkbox('setValue',false);
				}
                    
        }
        
            
    })
}
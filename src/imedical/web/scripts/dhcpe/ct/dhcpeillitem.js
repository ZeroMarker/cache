
//����   dhcpe/ct/dhcpeillitem.js
//����   ��������Ŀ����-��Ժ��
//����    2022-10-08
//������  sxt

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
var tableName = "DHC_PE_ILLItem";
var UserID=session['LOGON.USERID'];

$(function(){
	
	
    //��ȡ�����б�
    GetLocComp(SessionStr,SelectLocID);  
   
	$("#ILLSName").val(selectrowDesc);
    
    InitCombobox();
    
    InitILLItemDataGrid();
      
     //����
    $('#BClear').click(function(e){
        BClear_click();
    });
     
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
     
})

//���ݹ�������
function BRelateLoc_click()
{
    var DataID=$("#RowId").val();
    if (DataID==""){
        $.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
        return false;
    }
   var LocID=$("#LocList").combobox('getValue') 
   OpenLocWin(tableName,DataID,SessionStr,LocID,InitILLItemDataGrid)
}


function LoadIllExplain()
{
     $("#ILLEDItemGrid").datagrid('reload');
     $("#BRelateLoc").linkbutton('disable');
}

//����
function BClear_click(){
    	var LocID=session['LOGON.CTLOCID'];
		var LocListID=$("#LocList").combobox('getValue');
		if(LocListID!=""){var LocID=LocListID; }
		
    	$("#RowId").val("");
        $("#ItemDesc").combogrid('setValue',"");
        $("#ILLEDItemGrid").datagrid('load',{
            ClassName:"web.DHCPE.CT.IllnessStandard",
            QueryName:"FindIllItem",
            ILLSRowID:selectrow, 
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:LocID
        }); 
    
}
//����
function AddData(){
    Update("0");
}


//�޸�
function UpdateData(){
    Update("1");
}

function Update(Type){
    var ID=$("#RowId").val();
    
    if(Type=="0"){
        if(ID!==""){
             $.messager.alert('��ʾ','�������ݲ���ѡ�м�¼,������������',"info");
            return false;
        }
        var ID="";
    }
  
    var IllID=selectrow;
    var ItemID=$("#ItemDesc").combogrid('getValue');
    if (($("#ItemDesc").combogrid('getValue')==undefined)||($("#ItemDesc").combogrid('getValue')=="")){var ItemID="";}
    
    if (ItemID=="")
    {
        $.messager.alert('��ʾ','��Ŀ��������Ϊ��',"info");
         return false;
    }
   
    
    var NoActiveFlag=$("#NoActive").checkbox('getValue') ? "Y" : "N";
    var EmpowerFlag=$("#Empower").checkbox('getValue') ? "Y" : "N";
    var InString=ID+"^"+IllID+"^"+ItemID+"^"+NoActiveFlag;
    var Return=tkMakeServerCall("web.DHCPE.CT.IllnessStandard","UpdateItem",InString,tableName,UserID,$("#LocList").combobox('getValue'),EmpowerFlag);
    var flag=Return.split("^")[0]
    if (flag==0)
    {
        if(Type=="0"){
	        $.messager.popover({msg: '�����ɹ�',type:'success',timeout: 1000});
	     }
        BClear_click();
    }else{
        $.messager.alert('��ʾ',"����ʧ��","error");
    }
}

function InitCombobox(){

	var LocID=session['LOGON.CTLOCID'];
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	
    //��������
    var EDDescObj = $HUI.combogrid("#ItemDesc",{
        panelWidth:400,
        url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList",
        mode:'remote',
        delay:200,
        idField:'STORD_ARCIM_DR',
        textField:'STORD_ARCIM_Desc',
        onBeforeLoad:function(param){
            param.Desc = param.q;
					param.Type="B";
					param.LocID=LocID;
					param.hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",$('#LocList').combobox('getValue'));         
        },
        columns:[[
            {field:'STORD_ARCIM_DR',title:'ID',hidden: true},
            {field:'STORD_ARCIM_Desc',title:'����',width:200},
            {field:'STORD_ARCIM_Code',title:'����',width:80},
            {field:'STORD_ARCIM_Price',title:'�۸�',width:80},         
        ]]
        });
}

function InitILLItemDataGrid(){
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;

    $HUI.datagrid("#ILLEDItemGrid",{
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
            QueryName:"FindIllItem",
            ILLSRowID:selectrow, 
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:locId 
            
        },
        columns:[[
            {field:'TRowID',title:'ID',hidden: true},
            {field:'Item',title:'Item',hidden: true},
            {field:'ItemDesc',width:300,title:'��Ŀ����'},
            {field:'TNoActive',width:'100',title:'����',align:'center',
            	formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                  }
			},      
            {field:'TEmpower',width:'100',title:'������Ȩ',align:'center',
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
               
                $("#RowId").val(rowData.TRowID);
                if((rowData.TEmpower=="Y")){		
					$("#BRelateLoc").linkbutton('enable');
					$("#Empower").checkbox('setValue',true);
				}else{
					$("#Empower").checkbox('setValue',false);
					$("#BRelateLoc").linkbutton('disable');
				}
                
                if(rowData.TNoActive=="Y") $("#NoActive").checkbox('setValue',true)
                else $("#NoActive").checkbox('setValue',false)
   
                 $('#ItemDesc').combogrid('grid').datagrid('reload',{'q':rowData.ItemDesc}); 
                $("#ItemDesc").combogrid('setValue',rowData.Item)
                
        }
        
            
    })
}
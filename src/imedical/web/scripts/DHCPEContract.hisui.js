
//����    DHCPEContract.hisui.js
//����    �����ͬ
//����    2019.05.27
//������  xy

$(function(){
            
    Initdate();
    
    InitContractDataGrid();  
     
    //��ѯ
    $("#BFind").click(function() {  
        BFind_click();      
        });
      
    //����
    $("#BClear").click(function() { 
        BClear_click();     
        });
          
    //��������
    $("#BHomeSet").click(function() {   
        BHomeSet_click();       
        });
        
    //����
    $('#add_btn').click(function(e){
        AddData();
    });
    
    //�޸�
    $('#update_btn').click(function(){
        UpdateData();
    });
    
   
   
})

//����
function BClear_click()
{
    $("#Name,#No,#ID").val("");
    $("#StartDate").datebox('setValue',"");
    $("#EndDate").datebox('setValue',"");
    Initdate()
    $("#ContractGrid").datagrid('load',{
            ClassName:"web.DHCPE.Contract",
            QueryName:"SerchContractNew",
            Name:$("#Name").val(),
            No:$("#No").val(),
            SignDate:$("#SignDate").datebox('getValue'),
            StartDate:$("#StartDate").datebox('getValue'),
            EndDate:$("#EndDate").datebox('getValue'),
    }); 
}

//��������
function BHomeSet_click()
{
    
    
    var ID=$("#ID").val();
    
    if (ID=="" || ID==undefined){
        $.messager.alert("��ʾ",$g("��ѡ������õ������ͬ"),"info");
        return; 
    }
    
    var lnk="dhcpepregadm.home.hisui.csp?PGADMDr="+ID+"&Type=C";
    websys_lu(lnk,false,'width=800,height=630,hisui=true,title='+$g("��������"))
}

//��ѯ
function BFind_click()
{
    $("#ContractGrid").datagrid('load',{
            ClassName:"web.DHCPE.Contract",
            QueryName:"SerchContractNew",
            Name:$("#Name").val(),
            No:$("#No").val(),
            SignDate:$("#SignDate").datebox('getValue'),
            StartDate:$("#StartDate").datebox('getValue'),
            EndDate:$("#EndDate").datebox('getValue'),
    }); 
}


function AddData()
{
    
    BCRequired();
                    
    $("#myWin").show();
     
        var myWin = $HUI.dialog("#myWin",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'����',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                iconCls:'icon-w-save',
                text:'����',
                id:'save_btn',
                handler:function(){
                    SaveForm("")
                }
            },{
                iconCls:'icon-w-close',
                text:'�ر�',
                handler:function(){
                    myWin.close();
                    
                }
            }]
        });
        $('#form-save').form("clear");
        $("#ContractGrid").datagrid('reload');
        
    
}

SaveForm=function(id)
{
		
	 var No=$("#CNo").val();
	if (""==No) {
           	var valbox = $HUI.validatebox("#CNo", {
				required: true,
	   		});
			$.messager.alert('��ʾ',$g('��ͬ��Ų���Ϊ��!'),"info");
		
		return false;

	}
	
	var Name=$("#CName").val();
	if (""==Name) {
           	var valbox = $HUI.validatebox("#CName", {
				required: true,
	   		});
			$.messager.alert('��ʾ',$g('��ͬ���Ʋ���Ϊ��!'),"info");
		
		return false;

	}
	
	var Remark=$("#Remark").val();
	
	var SignDate=$("#SignDate").datebox('getValue');
	if (""==SignDate) {
           	var valbox = $HUI.datebox("#SignDate", {
				required: true,
	   		});
			$.messager.alert('��ʾ',$g('ǩ�����ڲ���Ϊ��!'),"info");
		
		return false;

	}	
	var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat");
	 if (dtformat=="YMD"){
		  var Year=SignDate.split("-")[0];
	  }
	  if (dtformat=="DMY"){
		 var Year=SignDate.split("/")[2];
	  }
	  
	if(Year<1840){
		$.messager.alert('��ʾ',$g('ǩ�����ڲ���С��1840��!'),"info"); 
		return false;
	}

    var UserID=session['LOGON.USERID'];
    
    var LocID=session['LOGON.CTLOCID'];
    
    Str=$.trim(No)+"^"+$.trim(Name)+"^"+$.trim(SignDate)+"^"+$.trim(Remark)+"^"+UserID+"^"+LocID;
    
    //alert(Str+"&"+id)
    if (id==""){
            var ret=tkMakeServerCall("web.DHCPE.Contract","Update","",Str);
    }else{
            var ret=tkMakeServerCall("web.DHCPE.Contract","Update",id,Str);

	}
	var retData=ret.split("^");
	if(retData!=-1){
		    $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		    $("#ContractGrid").datagrid('load',{
			    ClassName:"web.DHCPE.Contract",
				QueryName:"SerchContractNew",
				Name:$("#Name").val(),
				No:$("#No").val(),
		   	 	SignDate:$("#SignDate").datebox('getValue'),
		   	 	StartDate:$("#StartDate").datebox('getValue'),
		   	 	EndDate:$("#EndDate").datebox('getValue'),
			    }); 
				$("#ID").val("");
			$('#myWin').dialog('close'); 
	    }else{
		    $.messager.alert('������ʾ',$g("����ʧ��"),"error");
	    }
		
	}



    
function UpdateData()
{
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('��ʾ',$g("��ѡ����޸ĵļ�¼"),"info");
		return
	}
	
	BCRequired();
	   		
	if(ID!="")
	{	
	      	var Str=tkMakeServerCall("web.DHCPE.Contract","GetInfoByID",ID)
		  	var DataArr=Str.split("^"); 
		  	$("#ID").val(DataArr[0]);
		  	$("#CNo").val(DataArr[1]);
		  	$("#CName").val(DataArr[2]);
			$("#Remark").val(DataArr[4]);
			$("#SignDate").datebox('setValue',DataArr[3]);
			
			$("#myWin").show();
			
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'�޸�',
				modal:true,
				buttons:[{
					iconCls:'icon-w-save',
					text:'����',
					id:'save_btn',
					handler:function(){
						SaveForm(ID)
					}
				},{
					iconCls:'icon-w-close',
					text:'�ر�',
					handler:function(){
						myWin.close();
						 $("#ContractGrid").datagrid('reload');
					   $("#ID").val("");
					}
				}]
			});							
	}
}

//����Ĭ��ʱ��Ϊ����
function Initdate()
{
    var today = getDefStDate(0);
    $("#StartDate").datebox('setValue', today);
    $("#EndDate").datebox('setValue', today);
}

//��������ȡ��
function BCRequired()
{
    var valbox = $HUI.validatebox("#CNo,#CName", {
                required: false,
            });
    var valbox = $HUI.datebox("#SignDate", {
                required: false,
            });
}


function InitContractDataGrid()
{
    
    $HUI.datagrid("#ContractGrid",{
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
            ClassName:"web.DHCPE.Contract",
            QueryName:"SerchContractNew",
            Name:$("#Name").val(),
            No:$("#No").val(),
            SignDate:$("#SignDate").datebox('getValue'),
            StartDate:$("#StartDate").datebox('getValue'),
            EndDate:$("#EndDate").datebox('getValue'),
        },
        columns:[[
            {field:'TID',title:'ID',hidden: true},
            {field:'TNo',width:'200',title:'��ͬ���'},
            {field:'TName',width:'350',title:'��ͬ����'},
            {field:'TSignDate',width:'150',title:'ǩ������'},
            {field:'TRemark',width:'350',title:'��ע'},
            {field:'TCreateDate',width:'150',title:'¼������'},
            {field:'TCreateUser',width:'150',title:'¼����'},
            
            
        
        ]],
        onSelect: function (rowIndex, rowData) {
               
                $("#ID").val(rowData.TID);
                
                    
        }
        
            
    })

}



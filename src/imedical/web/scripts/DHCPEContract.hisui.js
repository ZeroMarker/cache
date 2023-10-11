
//名称    DHCPEContract.hisui.js
//功能    团体合同
//创建    2019.05.27
//创建人  xy

$(function(){
            
    Initdate();
    
    InitContractDataGrid();  
     
    //查询
    $("#BFind").click(function() {  
        BFind_click();      
        });
      
    //清屏
    $("#BClear").click(function() { 
        BClear_click();     
        });
          
    //主场设置
    $("#BHomeSet").click(function() {   
        BHomeSet_click();       
        });
        
    //新增
    $('#add_btn').click(function(e){
        AddData();
    });
    
    //修改
    $('#update_btn').click(function(){
        UpdateData();
    });
    
   
   
})

//清屏
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

//主场设置
function BHomeSet_click()
{
    
    
    var ID=$("#ID").val();
    
    if (ID=="" || ID==undefined){
        $.messager.alert("提示",$g("请选择待设置的团体合同"),"info");
        return; 
    }
    
    var lnk="dhcpepregadm.home.hisui.csp?PGADMDr="+ID+"&Type=C";
    websys_lu(lnk,false,'width=800,height=630,hisui=true,title='+$g("主场设置"))
}

//查询
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
            title:'新增',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                iconCls:'icon-w-save',
                text:'保存',
                id:'save_btn',
                handler:function(){
                    SaveForm("")
                }
            },{
                iconCls:'icon-w-close',
                text:'关闭',
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
			$.messager.alert('提示',$g('合同编号不能为空!'),"info");
		
		return false;

	}
	
	var Name=$("#CName").val();
	if (""==Name) {
           	var valbox = $HUI.validatebox("#CName", {
				required: true,
	   		});
			$.messager.alert('提示',$g('合同名称不能为空!'),"info");
		
		return false;

	}
	
	var Remark=$("#Remark").val();
	
	var SignDate=$("#SignDate").datebox('getValue');
	if (""==SignDate) {
           	var valbox = $HUI.datebox("#SignDate", {
				required: true,
	   		});
			$.messager.alert('提示',$g('签订日期不能为空!'),"info");
		
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
		$.messager.alert('提示',$g('签订日期不能小于1840年!'),"info"); 
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
		    $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
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
		    $.messager.alert('操作提示',$g("保存失败"),"error");
	    }
		
	}



    
function UpdateData()
{
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('提示',$g("请选择待修改的记录"),"info");
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
				title:'修改',
				modal:true,
				buttons:[{
					iconCls:'icon-w-save',
					text:'保存',
					id:'save_btn',
					handler:function(){
						SaveForm(ID)
					}
				},{
					iconCls:'icon-w-close',
					text:'关闭',
					handler:function(){
						myWin.close();
						 $("#ContractGrid").datagrid('reload');
					   $("#ID").val("");
					}
				}]
			});							
	}
}

//设置默认时间为当天
function Initdate()
{
    var today = getDefStDate(0);
    $("#StartDate").datebox('setValue', today);
    $("#EndDate").datebox('setValue', today);
}

//必填项标记取消
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
            {field:'TNo',width:'200',title:'合同编号'},
            {field:'TName',width:'350',title:'合同名称'},
            {field:'TSignDate',width:'150',title:'签订日期'},
            {field:'TRemark',width:'350',title:'备注'},
            {field:'TCreateDate',width:'150',title:'录入日期'},
            {field:'TCreateUser',width:'150',title:'录入人'},
            
            
        
        ]],
        onSelect: function (rowIndex, rowData) {
               
                $("#ID").val(rowData.TID);
                
                    
        }
        
            
    })

}



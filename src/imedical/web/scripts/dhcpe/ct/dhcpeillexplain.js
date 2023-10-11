
//名称    dhcpeillexplain.js
//功能    疾病解释维护-多院区
//创建    2021-08-14
//创建人  yupeng
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

var tableName = "DHC_PE_ILLSExplain";

var title="疾病解释"
if(Type=="2"){ 
    tableName = "DHC_PE_ILLSSportGuide";
}
if(Type=="3"){ 
    tableName = "DHC_PE_ILLSDietGuide";
}

var UserID=session['LOGON.USERID'];

$(function(){
             
    //获取下拉列表
    GetLocComp(SessionStr,SelectLocID);
	
    $("#ILLSName").val(selectrowDesc);
    
    if(Type=="1"){ 
    
        title="疾病解释"
        document.getElementById("TIllExplain").innerHTML=$g("疾病解释");
    }
    if(Type=="2"){ 
        title="运动指导"
        document.getElementById("TIllExplain").innerHTML=$g("运动指导");
    }
    if(Type=="3"){ 
        title="饮食指导"
        document.getElementById("TIllExplain").innerHTML=$g("饮食指导");
    }   
    
    InitILLExplainDataGrid();
      
    //新增
    $('#add_btn').click(function(e){
        AddData();
    });
    
    //修改
    $('#update_btn').click(function(){
        UpdateData();
    });

    //数据关联科室
    $("#BRelateLoc").click(function() { 
        BRelateLoc_click();     
     });

	  //科室下拉列表change
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


//数据关联科室
function BRelateLoc_click()
{
    var DataID=$("#ExplainRowId").val()
    if (DataID==""){
        $.messager.alert("提示","请选择需要授权的记录","info"); 
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

//新增
function AddData(){
    Update("0");
}

//修改
function UpdateData(){
    Update("2");
}


function Update(UpdateType){
    var ID=$("#ExplainRowId").val();
    
    if((UpdateType=="2")&&(ID=="")){
         $.messager.alert('提示','请选择待修改的记录',"info");
         return false;
    }
    if(UpdateType=="0"){var ID="";}
    var EDId=selectrow;
    var IllExplain=$("#IllExplain").val();
	var IllExplain=IllExplain.replace(new RegExp(" ","g"),"");
    if (IllExplain=="")
    {
        if((Type=="1")){
	        $.messager.alert('提示','疾病解释不能为空',"info");
         	return false;
        }
        if((Type=="2")){
	        $.messager.alert('提示','运动指导不能为空',"info");
         	return false;
        }
        if((Type=="3")){
	        $.messager.alert('提示','饮食指导不能为空',"info");
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
        if(UpdateType=="2"){$.messager.popover({msg:'修改成功',type:'success',timeout: 1000});}
        if(UpdateType=="0"){$.messager.popover({msg:'新增成功',type:'success',timeout: 1000});}
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
        $.messager.alert('提示',"操作失败","error");
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
            {field:'TNoActive',width:'40',title:'激活',align:'center',
            	formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    }
            },
            {field:'TEmpower',width:'70',title:'单独授权',align:'center',
            	formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    }
			},{ field:'TEffPowerFlag',width:100,align:'center',title:'当前科室授权',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			},
            {field:'TUpdateDate',width:'100',title:'更新日期'},
            {field:'TUpdateTime',width:'100',title:'更新时间'},
            {field:'TUserName',width:'100',title:'更新人'}
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
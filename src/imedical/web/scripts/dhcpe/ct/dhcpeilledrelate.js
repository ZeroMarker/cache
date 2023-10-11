
//名称    dhcpeilledrelate.js
//功能    疾病与建议对照
//创建    2021-08-15
//创建人  yupeng

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
var tableName = "DHC_PE_IDRelate";
var UserID=session['LOGON.USERID'];

$(function(){
	
    //获取下拉列表
    GetLocComp(SessionStr,SelectLocID) 
        
    $("#ILLSName").val(selectrowDesc);
    
    InitCombobox();
    
    InitILLEDRelateDataGrid();
      
     //清屏
    $('#BClear').click(function(e){
        BClear_click();
    });
     
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
	     
	     InitILLEDRelateDataGrid();  
	     
	       	var LocID=session['LOGON.CTLOCID'];
			var LocListID=$("#LocList").combobox('getValue');
			if(LocListID!=""){var LocID=LocListID; }
	      /********************建议描述重新加载****************************/
		    $("#EDDesc").combogrid('setValue',"");
	  		$HUI.combogrid("#EDDesc",{
				onBeforeLoad:function(param){
					param.DiagnoseConclusion = param.q;
            		param.LocID=LocID;
            		param.Eff="Y"; 

				}
		    });
		    
	       $('#EDDesc').combogrid('grid').datagrid('reload'); 
	       /********************建议描述重新加载****************************/
	    		 
       }
		
	});
     
})

//数据关联科室
function BRelateLoc_click()
{
    var DataID=$("#RowId").val();
    if (DataID==""){
        $.messager.alert("提示","请选择需要授权的记录","info"); 
        return false;
    }
   var LocID=$("#LocList").combobox('getValue') 
   OpenLocWin(tableName,DataID,SessionStr,LocID,InitILLEDRelateDataGrid)
}


function LoadIllExplain()
{
     $("#ILLEDRelateGrid").datagrid('reload');
     $("#BRelateLoc").linkbutton('disable');
}

//清屏
function BClear_click(){
    	$("#RowId").val("");
        $("#EDDesc").combogrid('setValue',"");
        $("#ILLEDRelateGrid").datagrid('load',{
            ClassName:"web.DHCPE.CT.IllnessStandard",
            QueryName:"EDCondition",
            ParrefRowId:selectrow,
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:$("#LocList").combobox('getValue') 
        }); 
    
}
//新增
function AddData(){
    Update("0");
}


//修改
function UpdateData(){
    Update("1");
}

function Update(Type){
    var ID=$("#RowId").val();
    
    if(Type=="0"){
        if(ID!==""){
             $.messager.alert('提示','新增数据不能选中记录,先清屏再新增',"info");
            return false;
        }
        var ID="";
    }
  
    var IllID=selectrow;
    var EDID=$("#EDDesc").combogrid('getValue');
    if (($("#EDDesc").combogrid('getValue')==undefined)||($("#EDDesc").combogrid('getValue')=="")){var EDID="";}
    
    if (EDID=="")
    {
        $.messager.alert('提示','建议描述不能为空',"info");
         return false;
    }
   
    
    var NoActiveFlag=$("#NoActive").checkbox('getValue') ? "Y" : "N";
    var EmpowerFlag=$("#Empower").checkbox('getValue') ? "Y" : "N";
    var InString=ID+"^"+EDID+"^"+IllID+"^"+NoActiveFlag;
    var Return=tkMakeServerCall("web.DHCPE.CT.IllnessStandard","UpdateIDR",InString,tableName,UserID,$("#LocList").combobox('getValue'),EmpowerFlag);
    var flag=Return.split("^")[0]
    if (flag==0)
    {
        if(Type=="0"){
	        $.messager.popover({msg: '操作成功',type:'success',timeout: 1000});
	     }
        BClear_click();
    }else{
        $.messager.alert('提示',"操作失败","error");
    }
}

function InitCombobox(){

	var LocID=session['LOGON.CTLOCID'];
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }

    //建议描述
    var EDDescObj = $HUI.combogrid("#EDDesc",{
        panelWidth:400,
        url:$URL+"?ClassName=web.DHCPE.CT.ExpertDiagnosis&QueryName=QueryED",
        mode:'remote',
        delay:200,
        idField:'ED_RowId',
        textField:'ED_DiagnoseConclusion',
        onBeforeLoad:function(param){
            param.DiagnoseConclusion = param.q;
			param.LocID=LocID;
            param.Eff="Y";
        },
        columns:[[
            {field:'ED_RowId',title:'ID',hidden: true},
            {field:'ED_DiagnoseConclusion',title:'结论',width:100},
            {field:'ED_Detail',title:'建议',width:180},
            {field:'ED_Code',title:'编码',width:80},         
        ]]
        });
}

function InitILLEDRelateDataGrid(){
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;

    $HUI.datagrid("#ILLEDRelateGrid",{
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
            QueryName:"EDCondition",
            ParrefRowId:selectrow, 
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:locId 
            
        },
        columns:[[
            {field:'TRowID',title:'ID',hidden: true},
            {field:'TEDID',title:'EDID',hidden: true},
            {field:'TILLNessDesc',width:100,title:'疾病描述'},
            {field:'TEDDesc',width:100,title:'建议描述'},
            {field:'TEDDetail',width:580,title:'建议内容'},
             {field:'TNoActive',width:'100',title:'激活',align:'center',
            	formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
                  }
			},      
            {field:'TEmpower',width:'100',title:'单独授权',align:'center',
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
   
                $('#EDDesc').combogrid('grid').datagrid('reload',{'q':rowData.TEDDesc}); 
                $("#EDDesc").combogrid('setValue',rowData.TEDID)
                
        }
        
            
    })
}
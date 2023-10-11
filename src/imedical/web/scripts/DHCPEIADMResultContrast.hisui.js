
//名称   DHCPEIADMResultContrast.hisui.js
//功能	结果比对hisui
//创建	2021.01.21
//创建人  xy

$(function(){
		
	
	InitIADMResultContrastGrid();
	    
     //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
           
     //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });  
          
        

   $("#RegNo").keydown(function(e) {	
			if(e.keyCode==13){
				BFind_click();
				}
	});
	
	
	$("#Name").keydown(function(e) {	
			if(e.keyCode==13){
				BFind_click();
				}
	});
	
	//结果对比
	$("#BReaultContrast").click(function() {	
		BReaultContrast_Click();		
        });  
          
	
	//对比列表
	$("#BResultContrastList").click(function() {	
		BResultContrastList_Click();		
        });  

	
})

//结果对比
function BReaultContrast_Click()
{
	var ShowAbnormal="N";
	var IADM="",IADMStr="";
	
	
	var RegNo=$("#RegNo").val();
	/*
	if(RegNo==""){
		$.messager.alert("提示","请输入登记号","info");
    	return false;
	}*/
	
	var DateFrom=$("#StartDate").datebox('getValue');
	var DateTo=$("#EndDate").datebox('getValue');
	var RegNo="",Flag=0;
	var selectrow = $("#IADMResultContrastGrid").datagrid("getChecked");//获取的是数组，多行数据
  	for(var i=0;i<selectrow.length;i++){
	  	var IADM=selectrow[i].RPT_PAADM_DR;
	  	if (IADMStr==""){IADMStr=IADM;}
			 else {IADMStr=IADMStr+"^"+IADM;}
			 if((RegNo!="")&&(selectrow[i].RPT_RegNo!=RegNo)) Flag=1;
             RegNo=selectrow[i].RPT_RegNo;
  	}
	if(Flag==1){
         $.messager.alert("提示","只能比较本人体检记录","info");
         return false;
    }
	if(IADMStr.split("^").length>3){
	     $.messager.alert("提示","就诊记录不能超过三次","info");
    	return false;
    }
	if(IADMStr.split("^").length==1){
         $.messager.alert("提示","至少选择2条体检记录","info");
        return false;
    }
    if (IADMStr==""){
	    $.messager.alert("提示","请选择对比的就诊记录","info");
    	return false;
    	}
	var lnk="dhcpepatresulthistory.csp?AdmId="+IADMStr+"&RegNo="+RegNo+"&DateFrom="+DateFrom+"&DateTo="+DateTo+"&ShowAbnormal="+ShowAbnormal;
	//websys_lu(lnk,false,'width=1300,height=650,hisui=true,title=结果对比')
	$HUI.window("#ReaultContrastWin", {
        title: "结果对比",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1300,
        height: 750,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });
	
}

//对比列表
function BResultContrastList_Click()
{
	
	var RegNo=$("#RegNo").val();
	/*
	if(RegNo==""){
		$.messager.alert("提示","请输入登记号","info");
    	return false;
	}
	*/
	var lnk="dhcpepatresulthistorylist.csp?&RegNo="+RegNo;
	//websys_lu(lnk,false,'width=800,height=550,hisui=true,title=对比列表')
	$HUI.window("#ResultContrastListWin", {
        title: "对比列表",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 800,
        height: 550,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });

}

function BClear_click()
{
	$("#RegNo,#Name").val("");
	$("#StartDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	BFind_click();
}


//查询
function BFind_click(){
	
	var CTLocID=session['LOGON.CTLOCID'];
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo,
            "CTLocID":CTLocID
            
		}, false);
		
			$("#RegNo").val(iRegNo)
		}	
	$("#IADMResultContrastGrid").datagrid('load',{
			ClassName:"web.DHCPE.Report",
			QueryName:"SearchIADM",
			DateFrom:$("#StartDate").datebox('getValue'),
			DateTo:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			PatName:$("#Name").val()
			
			})
	
}


function InitIADMResultContrastGrid()
{
	$HUI.datagrid("#IADMResultContrastGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Report",
			QueryName:"SearchIADM",
			DateFrom:$("#StartDate").datebox('getValue'),
			DateTo:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			PatName:$("#Name").val()
			
			
		},
		columns:[[
		    {field:'RPT_RowId',title:'RPTRowId',hidden: true},
		    {field:'RPT_IADM_DR',title:'IADM',hidden: true},
		    {field:'RPT_PAADM_DR',title:'PAADM',hidden: true},
		    {title: '选择',field: 'Select',width: 60,checkbox:true},
		    {field:'RPT_RegNo',width:150,title:'登记号'},
		    {field:'RPT_IADM_DR_Name',width:180,title:'姓名'},
			{field:'RPT_IADM_RegDate',width:120,title:'登记日期'},
			{field:'RPT_GADM_DR_Name',width:450,title:'单位'},
			{field:'RPT_IADM_Sex',width:70,title:'性别'},
			{field:'RPT_IADM_Age',width:100,title:'年龄'},
			{field:'RPT_IADM_DOB',width:120,title:'出生日期'},
			{field:'THPNO',width:150,title:'体检号'} 
		
			
		]],
		onSelect: function (rowIndex, rowData) {
			  						
		}
		
			
	})
}


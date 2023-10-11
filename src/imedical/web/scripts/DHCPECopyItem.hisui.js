
//名称    DHCPECopyItem.hisui.js
//功能    复制项目
//创建    2022.04.22
//创建人  xy

$(function() {
    
    
    //初始化体检列表
    InitPersonGrid();
    
    //初始化项目信息
    InitPersonItemGrid();
    
    $("#RegNo").keydown(function(e) {
            
            if(e.keyCode==13){
                BFind_click();
            }
            
        });
        
    $("#PatName").keydown(function(e) {
            
            if(e.keyCode==13){
                BFind_click();
            }    
        });
        
    //查询
    $('#BFind').click(function(e){
        BFind_click();
    });
    
    //复制项目
    $('#BCopyItem').click(function(e){
        BCopyItem_click();
    });    
    
})


//查询
function BFind_click() {
	var HospID = session['LOGON.HOSPID'];
	var CTLocID=session['LOGON.CTLOCID'];
    var RegNoLength = tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
    var iRegNo = $("#RegNo").val();
    if (iRegNo.length < RegNoLength && iRegNo.length > 0) {
        iRegNo = tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
        $("#RegNo").val(iRegNo);
    }
    var iName = $("#PatName").val();
    
    var ShowTotal="N";
    
    $("#PersonTab").datagrid('load', {
        ClassName: "web.DHCPE.PreIADM",
        QueryName: "SearchPreIADM",
        RegNo: iRegNo,
        Name:iName,
        Status:"^ARRIVED^",
        HospID: HospID,
        ShowTotal:ShowTotal,
    });
    
     $('#PersonItemTab').datagrid('loadData', {
			total: 0,
			rows: []
		});
    
}

//病人列表
function InitPersonGrid()
{
    $HUI.datagrid("#PersonTab",{
        url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,  
        pageSize: 20,
        pageList : [20,100,200],
        displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据" 
        singleSelect: true,
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCPE.PreIADM",
            QueryName:"SearchPreIADM"
        },
        columns:[[
        	{field:'PIADM_RowId',title:'PIADMID',hidden: true},
            {field:'TNewHPNo',width:'100',title:'体检号'},
            {field:'PIADM_PIBI_DR_Name',width:'100',title:'姓名'},
            {field:'TAdmDate',width:'100',title:'体检日期'}
            
            
        ]],
        onSelect: function (rowIndex, rowData) {
            
           setValueById("FromPreIADM",rowData.PIADM_RowId);
            
            $('#PersonItemTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			
			 LoadPersonItem(rowData);    
                                                
        }
        
            
    })
}

function  LoadPersonItem(rowData) {
	
    SelectItems=[];
    
    $("#PersonItemTab").datagrid('load', {
          ClassName: "web.DHCPE.Query.PreItemList",
          QueryName: "QueryPreItemList",
          AdmId: rowData.PIADM_RowId,
          AdmType:"PERSON"
            });
	
}


//病人项目列表
function InitPersonItemGrid()
{
    $HUI.datagrid("#PersonItemTab",{
        url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers: true, //如果为true, 则显示一个行号列  
        showFooter: true,
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        pageSize: 20,
		pageList: [20, 30, 40, 50],
        singleSelect: true,
		selectOnCheck: false,
		checkOnSelect:false,
        queryParams:{
            ClassName:"web.DHCPE.Query.PreItemList",
            QueryName:"QueryPreItemList"
        },
        columns:[[
            {field:'RowId',checkbox:true},
            {field:'ItemId',title:'ArcItemID',hidden: true},
            {field:'ItemDesc',width:'250',title:'项目'},
            {field:'ItemSetDesc',width:'200',title:'套餐'},
            {field:'TAccountAmount',width:'100',title:'金额'},
            {field:'TRecLocDesc',width:'170',title:'接收科室'}    
        ]],
        //取消选中行函数	
		onUncheck:function(rowIndex,rowData){
				RemoveSelectItem(rowIndex,rowData);
			},
		//选中行函数
		onCheck:function(rowIndex,rowData){
				AddSelectItem(rowIndex,rowData); 
			},
		onCheckAll: function (rows) { 
				//遍历datagrid的行 
		 		$.each(rows, function (index) {
			 		$('#PersonItemTab').datagrid('checkRow',index);
			 	});
			 		
				
		},
		onUncheckAll: function (rows) { 
				//遍历datagrid的行 
		 		$.each(rows, function (index) {
			 		$('#PersonItemTab').datagrid('uncheckRow',index);
			 	});
			 		
				
		},

		onLoadSuccess: function (rowData) { 
	
	  		$('#PersonItemTab').datagrid('unselectAll');
	  		var FromPreIADM=$("#FromPreIADM").val();
	  		var info=tkMakeServerCall("web.DHCPE.Query.PreItemList","GetCopyItem",FromPreIADM);
	    	var objtbl = $("#PersonItemTab").datagrid('getRows');
	        if (rowData) {
		         //遍历datagrid的行            
		 		$.each(rowData.rows, function (index) { 
	        		if(info.indexOf(objtbl[index].RowId)>=0){
				 		//加载页面时根据后台类方法返回值判断datagrid里面checkbox是否被勾选
				 		$('#PersonItemTab').datagrid('checkRow',index);
					 }
			   });
	        }
		}
        
            
    })
        
 
}

var SelectItems=[];

function FindSelectItem(ID) { 
 	//alert("SelectItems.length:"+SelectItems.length)
      for (var i = 0; i < SelectItems.length; i++) { 
            if (SelectItems[i] == ID) return i; 
         } 
       return -1; 
  } 

function AddSelectItem(rowIndex,rowData)
{
	 var SelectIds="";
	
     if (FindSelectItem(rowData.RowId+","+rowData.ItemId) == -1) { 
         SelectItems.push(rowData.RowId+","+rowData.ItemId);  	
      }
                
      for (var i = 0; i < SelectItems.length; i++) { 
          if(SelectIds==""){
	          var SelectIds=SelectItems[i];
          }else{
	          var SelectIds=SelectIds+"^"+SelectItems[i];
          }
               
       }
                  
    var FromPreIADM=$("#FromPreIADM").val();
	var UserID=session['LOGON.USERID'];
    var flag=tkMakeServerCall("web.DHCPE.Query.PreItemList","SetCopyItem",FromPreIADM,SelectIds,UserID);
	  
}

function RemoveSelectItem(rowIndex, rowData) { 

    var SelectIds="";
    
    var k = FindSelectItem(rowData.RowId+","+rowData.ItemId); 
    
    if (k != -1) { 
             SelectItems.splice(k,1);
      } 
      
     
    for (var i = 0; i < SelectItems.length; i++) { 
           if(SelectIds==""){
	          var SelectIds=SelectItems[i];
          }else{
	          var SelectIds=SelectIds+"^"+SelectItems[i];
          }  
      }
      
	 if(SelectIds=="^"){var SelectIds="";}
	
	var FromPreIADM=$("#FromPreIADM").val();
	var UserID=session['LOGON.USERID'];
    var flag=tkMakeServerCall("web.DHCPE.Query.PreItemList","SetCopyItem",FromPreIADM,SelectIds,UserID);
                     
  } 
 



//复制项目
function BCopyItem_click()
{
    var FromPreIADM=getValueById("FromPreIADM");
    if (ToPreIADM=="") {
	    $.messager.alert("提示","请选择被复制的人员！",'info');
	    return false;
    }
    if (FromPreIADM==ToPreIADM) 
    {
	    $.messager.alert("提示","预约人员和被复制的人员同一个人，无需复制项目！",'info');
	    return false;
    }
     
    
    var rows=tkMakeServerCall("web.DHCPE.Query.PreItemList","GetCopyItem",FromPreIADM);
    if(rows==""){
	    $.messager.alert("提示","请选择待复制项目！",'info');
	    return false;
    }
    var ItemLength=rows.split("^").length;
    for(var i=0;i<ItemLength;i++)
    {
	    var ItemStr=rows.split("^")[i];
	    var ItemStrOne=ItemStr.split(",");
        var ArcItemID=ItemStrOne[1];
        parent.AddItem(ArcItemID);
    } 
	var flag=tkMakeServerCall("web.DHCPE.Query.PreItemList","DeleteCopyItem",FromPreIADM);

    parent.$("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:ToPreIADM,AdmType:ToAdmType,PreOrAdd:ToPreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""});
    parent.$('#CopyItemWin').window('close'); 
    
}
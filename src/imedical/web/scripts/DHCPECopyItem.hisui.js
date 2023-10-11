
//����    DHCPECopyItem.hisui.js
//����    ������Ŀ
//����    2022.04.22
//������  xy

$(function() {
    
    
    //��ʼ������б�
    InitPersonGrid();
    
    //��ʼ����Ŀ��Ϣ
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
        
    //��ѯ
    $('#BFind').click(function(e){
        BFind_click();
    });
    
    //������Ŀ
    $('#BCopyItem').click(function(e){
        BCopyItem_click();
    });    
    
})


//��ѯ
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

//�����б�
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
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������" 
        singleSelect: true,
        selectOnCheck: true,
        queryParams:{
            ClassName:"web.DHCPE.PreIADM",
            QueryName:"SearchPreIADM"
        },
        columns:[[
        	{field:'PIADM_RowId',title:'PIADMID',hidden: true},
            {field:'TNewHPNo',width:'100',title:'����'},
            {field:'PIADM_PIBI_DR_Name',width:'100',title:'����'},
            {field:'TAdmDate',width:'100',title:'�������'}
            
            
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


//������Ŀ�б�
function InitPersonItemGrid()
{
    $HUI.datagrid("#PersonItemTab",{
        url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers: true, //���Ϊtrue, ����ʾһ���к���  
        showFooter: true,
        pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
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
            {field:'ItemDesc',width:'250',title:'��Ŀ'},
            {field:'ItemSetDesc',width:'200',title:'�ײ�'},
            {field:'TAccountAmount',width:'100',title:'���'},
            {field:'TRecLocDesc',width:'170',title:'���տ���'}    
        ]],
        //ȡ��ѡ���к���	
		onUncheck:function(rowIndex,rowData){
				RemoveSelectItem(rowIndex,rowData);
			},
		//ѡ���к���
		onCheck:function(rowIndex,rowData){
				AddSelectItem(rowIndex,rowData); 
			},
		onCheckAll: function (rows) { 
				//����datagrid���� 
		 		$.each(rows, function (index) {
			 		$('#PersonItemTab').datagrid('checkRow',index);
			 	});
			 		
				
		},
		onUncheckAll: function (rows) { 
				//����datagrid���� 
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
		         //����datagrid����            
		 		$.each(rowData.rows, function (index) { 
	        		if(info.indexOf(objtbl[index].RowId)>=0){
				 		//����ҳ��ʱ���ݺ�̨�෽������ֵ�ж�datagrid����checkbox�Ƿ񱻹�ѡ
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
 



//������Ŀ
function BCopyItem_click()
{
    var FromPreIADM=getValueById("FromPreIADM");
    if (ToPreIADM=="") {
	    $.messager.alert("��ʾ","��ѡ�񱻸��Ƶ���Ա��",'info');
	    return false;
    }
    if (FromPreIADM==ToPreIADM) 
    {
	    $.messager.alert("��ʾ","ԤԼ��Ա�ͱ����Ƶ���Աͬһ���ˣ����踴����Ŀ��",'info');
	    return false;
    }
     
    
    var rows=tkMakeServerCall("web.DHCPE.Query.PreItemList","GetCopyItem",FromPreIADM);
    if(rows==""){
	    $.messager.alert("��ʾ","��ѡ���������Ŀ��",'info');
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
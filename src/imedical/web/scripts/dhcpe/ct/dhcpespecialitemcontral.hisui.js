
//����	dhcpe/ct/dhcpespecialitemcontral.hisui.js
//����	���������ĿȨ�޹���
//����	2021.11.04
//������  xueying

var lastIndex = "";

var EditIndex = -1;

var tableName = "DHC_PE_SpecialContral";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	GetLocComp(SessionStr)
	
	InitCombobox();
	
	//��ʼ��Grid
	InitSpecItemContDataGrid();
    
    //����
	$("#BAdd").click(function() {	
		BAdd_click();		
        });  
        
     //�޸�
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        }); 
         
    //ɾ��
	$("#BDelete").click(function() {	
		Delete_Click();		
        });
        
    //����
	$("#BSave").click(function() {	
		BSave_Click();		
        });
        
    //����
    $("#BClear").click(function() {	
		BClear_Click();		
        });
        
      
     //���������б�change
	$("#LocList").combobox({
       onSelect:function(){
	       
	        	var LocID=$("#LocList").combobox('getValue');
		   		if(LocID==undefined) LocID=session['LOGON.CTLOCID'];
		   		var hospId=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		   		
			    
			    
			    /*****************�û����¼���(combobox)*****************/
			    //$('#UserName').combogrid('grid').datagrid('reload'); //�ؼ���
			    $HUI.combogrid("#UserName",{
					onBeforeLoad:function(param){
							param.Desc = param.q;
							param.Type="B";
							param.LocID=LocID;
							param.hospId=hospId;

					}
		       });
		    
	           $('#UserName').combogrid('grid').datagrid('reload'); 
			   /*****************�û����¼���(combobox)*****************/
			    
			   /*****************������Ŀ���¼���(combobox)*****************/
		   	    var url= $URL+"?ClassName=web.DHCPE.CT.SpecialItemContral&QueryName=SearchSpecialItem&ResultSetType=array&LocID="+LocID;
			    $('#SpecialItem').combobox('reload',url);
			    /*****************������Ŀ���¼���(combobox)*****************/
			    
		   		$("#SpecialItemContralTab").datagrid('load',{
					ClassName:"web.DHCPE.CT.SpecialItemContral",
					QueryName:"SearchSpecialItemContral",
					LocID:LocID
				});
			
		}
	})
	  
   })
   



//����
function BClear_Click(){
	
	$('#LocList').combobox('setValue',session['LOGON.CTLOCID']);
	
	$("#UserName").combogrid('enable');	
	$("#UserName").combogrid('setValue',"");
		
	$('#SpecialItem').combobox('setValue',"");
	
	$('#ID').val("");
	$("#UserID").val("");
	
	$("#SpecialItemContralTab").datagrid('load',{
		ClassName:"web.DHCPE.CT.SpecialItemContral",
		QueryName:"SearchSpecialItemContral",
		LocID:$("#LocList").combobox("getValue")
	});
}

//�޸�
function BUpdate_click(){
	Save(1);
}

//����
function BAdd_click()
{
	Save(0);
}

function Save(Type){
	
	var ID=$("#ID").val();
	
	if(Type=="1")
	{
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵ�����","info");
			return false;
		}	
	}else{
		if(ID!=""){
			
			$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,��������������","info");
			return false;
		}
		
	}
	//�û�
	var UserID=$("#UserName").combogrid('getValue')
	 if (($("#UserName").combogrid('getValue')==undefined)||($("#UserName").combogrid('getValue')=="")){var UserID="";}
   
	if (UserID!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsUser",UserID);
			if(ret=="0"){
				$.messager.alert("��ʾ","��ѡ���û�","info");
				return false;
				}
		}else{
			var valbox = $HUI.combogrid("#UserName", {
				required: true,
	    	});
			$.messager.alert("��ʾ","�û�����Ϊ��","info");
			return false;
	}
	
	 //����
	 var LocID=$("#LocList").combobox("getValue");
	 
	 var ExsistFlag=tkMakeServerCall("web.DHCPE.CT.SpecialItemContral","IsExsistSpeItemContral",UserID,LocID)
	 if((ExsistFlag=="1")&&(ID=="")){
		 $.messager.alert("��ʾ","���û��Ѿ�ά��������Ŀ���������������޸ģ�","info");
			return false;
	 }
	 

	 //������Ա
	 var SessionUser=session['LOGON.USERID'];
	 
	 //������Ŀ
    var SpecialItem=$("#SpecialItem").combobox("getValues");
    if(SpecialItem==""){
	    	$.messager.alert("��ʾ","������Ŀ����Ϊ��","info");
			return false;
    }
    
    var SpecialItemStr=SpecialItem.join("^");
     //alert(SpecialItemStr)
	var ret=tkMakeServerCall("web.DHCPE.CT.SpecialItemContral","SaveSpecialItemContral",UserID,LocID,SpecialItemStr,SessionUser);
	var retone=ret.split("^");
	if(retone[0]=="0"){
		$.messager.popover({msg: retone[1],type:'success',timeout: 1000});
		BClear_Click();
	}else{
		$.messager.alert("��ʾ",retone[1],"error")	
	}

	
}

//ɾ��
function Delete_Click()
 {
    var SessionUserID=session['LOGON.USERID'];
	var ID=$("#ID").val();
	if (""==ID) {
		$.messager.alert("��ʾ","����ѡ���ɾ���ļ�¼","info");	
		return false;
	 }
	var UserID=$("#UserID").val();
    var LocID=$("#LocList").combobox("getValue");
	var ret="";
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.CT.SpecialItemContral", MethodName:"DelSpecialItemContral",UserID:UserID,LocID:LocID,SessionUserID:SessionUserID},function(ReturnValue){
				if (ReturnValue.split("^")[0]=='-1') {
					$.messager.alert("��ʾ",ReturnValue.split("^")[1],"error");  
				}else{
					$.messager.popover({msg: ReturnValue.split("^")[1],type:'success',timeout: 1000});
					BClear_Click();	
     
				}
			});	
		}
	});
	
	
 }

 
 
function InitCombobox()
{
  
    var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	  
	//������Ŀ
    var SpecialItemObj = $HUI.combobox("#SpecialItem",{
        url:$URL+"?ClassName=web.DHCPE.CT.SpecialItemContral&QueryName=SearchSpecialItem&ResultSetType=array&LocID="+LocID,
        valueField:'id',
        rowStyle:'checkbox',
        textField:'desc',
        multiple:true,
        selectOnNavigation:false,
        panelHeight:300,
        editable:false
    });
	
    //����Ա
	var OPNameObj = $HUI.combogrid("#UserName",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXTNew",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 20,
		pageList: [20,50,100],
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=LocID;
			param.hospId=hospId;

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:50},
			{field:'DocName',title:'����',width:200},
			{field:'Initials',title:'����',width:190}	
				
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',""); 
		},

		});	 
		
	
	
	
} 

function InitSpecItemContDataGrid()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	$HUI.datagrid("#SpecialItemContralTab",{
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
			ClassName:"web.DHCPE.CT.SpecialItemContral",
			QueryName:"SearchSpecialItemContral",
			LocID:LocID
		},
		columns:[[
	        {field:'ID',hidden: true},
		    {field:'UserID',hidden: true},
		    {field:'ItemIDStr',hidden: true},
			{field:'UserCode',width:'150',title:'����'},
			{field:'UserName',width:'150',title:'ҽ��'},
			{field:'ArcDescStr',width:'900',title:'������Ŀ'}
			
		]],
		onSelect: function (rowIndex, rowData) {
		
			  $("#ID").val(rowData.ID);
			  $("#UserID").val(rowData.UserID);
			  var UserName=rowData.UserName;
			  $('#UserName').combogrid('grid').datagrid('reload',{'q':UserName});
			  $("#UserName").combogrid('setValue',rowData.UserID);
			  $("#UserName").combogrid('disable');
			  GetSpecialItem(rowData.ItemIDStr);
			
		}
		
			
	})

}


function GetSpecialItem(ItemIDStr){
	
	//���վ��
    var str=ItemIDStr.split("^")
    var retarray=new Array();
    for(var i=0;i<str.length;i++)
    {
        retarray.push(str[i]);
        //var checkid=str[i];
        var checkid=str[i].split("||")[0];
        $("#"+checkid).attr("checked",true);
    }
    
    $("#SpecialItem").combobox("setValues",retarray);
}



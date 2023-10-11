
/*
 * FileName: dhcpe/ct/dhcpechartassign.hisui.js
 * Author:  sxt
 * Date: 2021-08-14
 * Description: ���ҽ��Ȩ�޹��� 
 */
var lastIndex = "";
var EditIndex = -1;
var tableName = "DHC_PE_ChartAssign";
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	//��ȡ���������б�
	GetLocComp(SessionStr)
	
	InitCombobox();
	
	//��ʼ�� �û�����Grid
	InitChartAssignDataGrid();
    
    //��ʼ�� ����Ȩ��Grid
    InitChartAssignDetailDataGrid(); 
    
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
     
     //���������б�change
	$("#LocList").combobox({
       onSelect:function(){
	       
	        var LocID=session['LOGON.CTLOCID']
			var LocListID=$("#LocList").combobox('getValue');
			if(LocListID!=""){var LocID=LocListID; }
		    var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		    
		     /*****************�û����¼���(combogrid)*****************/
		    // var UserNameUrl=$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT&LocID="+LocID+"&hospId="+hospId;
		    //$('#UserName').combogrid('grid').datagrid('options').url=UserNameUrl; 
		    $HUI.combogrid("#UserName",{
				onBeforeLoad:function(param){
					param.Desc = param.q;
					param.Type="B";
					param.LocID=LocID;
					param.hospId = hospId; 

				}
		    });
		    
	       $('#UserName').combogrid('grid').datagrid('reload'); 
	       /*****************�û����¼���(combogrid)*****************/
		    
		     /*****************��ȫ�����¼���(combobox)*****************/
		    var GroupNameurl=$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array&hospId="+hospId;
			$('#GroupName').combobox('reload',GroupNameurl);
			 /*****************��ȫ�����¼���(combobox)*****************/
			 //BClear_click();
			 
			BFind_click();
			
			$('#ChartAssignDetailTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			/*
			$("#ChartAssignDetailTab").datagrid('load', {
				ClassName:"web.DHCPE.CT.ChartAssign",
				QueryName:"SerchChartDetail",
				ChartID:"",
				LocID:LocID
		
			});
			*/
			
		}
	})
	
	
	  
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
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
		BDelete_Click();		
        }); 
        
     
        
     //����
	$("#BSave").click(function() {	
		BSave_Click();		
        });
   
   //ȫѡ��д
	$('#SelectAllUse').checkbox({
		onCheckChange:function(e,vaule){
			BSelectAllUse_change(vaule);
		}
			
	});
   
   
   //ȫѡ�ɶ�
	$('#SelectAllWrite').checkbox({
		onCheckChange:function(e,vaule){
			BSelectAllWrite_change(vaule);		
			}
			
	});
    
 })
    
    
    
 //ȫѡ�ɶ�
function BSelectAllUse_change(value){
	if (value==true) 
	{
		var SelectAll=1;
	}
	else
	{ 
		var SelectAll=0;
	}
	var objtbl = $("#ChartAssignDetailTab").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{   
		setColumnValue(i,"TUseFlag",SelectAll);
	
	}	   
}


function BSelectWrite_change(value,rowIndex){
	 if (value==true) 
	{
		var SelectAll=1;
	}
	else
	{ 
		var SelectAll=0;
	}
	//alert(value+"^"+rowIndex)
	var objtbl = $("#ChartAssignDetailTab").datagrid('getRows');
	setColumnValue(rowIndex,"TWrite",SelectAll);
}

  //ȫѡ��д
 function BSelectAllWrite_change(value){
	 
	 if (value==true) 
	{
		var SelectAll=1;
	}
	else
	{ 
		var SelectAll=0;
	}
	var objtbl = $("#ChartAssignDetailTab").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{   
		setColumnValue(i,"TWrite",SelectAll);
	
	}	   
 }
    
 function InitCombobox(){

      var LocID=session['LOGON.CTLOCID']
	  var LocListID=$("#LocList").combobox('getValue');
	  if(LocListID!=""){var LocID=LocListID; }
	  var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
    
	 //����Ա
	  var OPNameObj = $HUI.combogrid("#UserName",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXTNew",
		mode:'remote',
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=LocID;
			param.hospId = hospId; 

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:60},
			{field:'DocName',title:'����',width:200},
			{field:'Initials',title:'����',width:140}	
				
		]]

		});	
		 
		
	//��ȫ��
	var GroupObj = $HUI.combobox("#GroupName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array&hospId="+hospId,
		valueField:'id',
		textField:'desc',

	});	
	
	    
 
 }
    
/****************************************�û�����************************************/ 
//��ѯ
function BFind_click(){
	var LocID=$("#LocList").combobox('getValue');
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		
	//����
	var activeflag="N";
	var active=$("#Active").checkbox('getValue');
	if(active) activeflag="Y";
	
	//סԺҽ��
	var IsInDocFlag="N";
	var IsInDoc=$("#IsInDoc").checkbox('getValue');
	if(IsInDoc) IsInDocFlag="Y";
	
	$("#ChartAssignTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.ChartAssign",
			QueryName:"SerchChartAssign",
			UserID:$("#UserName").combogrid('getValue'),
		    GroupID:$("#GroupName").combobox('getValue'),
			LocID:LocID,
			hospId:hospId,
			ActiveFlag:activeflag,
			InDoc:IsInDocFlag    
		});	
} 

//����
function BClear_click(){
	$("#UserName").combogrid('setValue',"");
	$("#GroupName").combobox('setValue',"");
	$("#LocList").combobox('setValue',"");
	$("#UserID,#GroupID,#LocID,#ChartID").val("");
	var valbox = $HUI.combogrid("#UserName", {
				required: false,
	    	});
	var valbox = $HUI.combobox("#GroupName", {
				required: false,
	    	});
	var valbox = $HUI.combobox("#LocList", {
				required: false,
	    	});
	 BFind_click();
	 InitChartAssignDetailDataGrid();
	
}

//����
function BAdd_click(){
	Update("0");
}

function BUpdate_click()
{
	Update("2");
	} 

//ɾ��
function BDelete_Click(){
	Update("1");
	
}

function Update(Type){


	if(Type=="1")
	{
		var ID=$("#UserID").val();
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
			return false;
		}
		var LocID=$("#LocID").val();
		var GroupID=$("#GroupID").val();
		var UserId=session['LOGON.USERID'];
		$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			var ChartID=$("#ChartID").val();
			var ActiveFlag="N";
			$.m({ ClassName:"web.DHCPE.CT.ChartAssign", MethodName:"UpdateAssign", Type:'1',ID:ChartID,sessionUser:UserId},function(ReturnValue){
				if (ReturnValue.split("^")[0]!='0') {
					$.messager.alert("��ʾ",ReturnValue.split("^")[1],"error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					BClear_click();
					
	
			        //$('#myWin').dialog('close'); 
				}
			});	
		}
	});
	
	}
	
	if(Type=="0")
	{
		var ID=$("#UserID").val();
		if(ID!=""){
			
			$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,��������������","info");
			return false;
		}
		
	var UserID=$("#UserName").combogrid('getValue');
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
	
	var LocID=$("#LocList").combogrid('getValue');
	if (($("#LocList").combogrid('getValue')==undefined)||($("#LocList").combogrid('getValue')=="")){var LocID="";}
	 if (LocID!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsCTLoc",LocID);
			if(ret=="0"){
				$.messager.alert("��ʾ","��ѡ�����","info");
				return false;
				}
		}else{
			var valbox = $HUI.combogrid("#LocList", {
				required: true,
	    	});
			$.messager.alert("��ʾ","���Ҳ���Ϊ��","info");
			return false;
			
		}
	
	var GroupID=$("#GroupName").combobox('getValue');
	if (($("#GroupName").combobox('getValue')==undefined)||($("#GroupName").combobox('getValue')=="")){var GroupID="";}
	 if (GroupID==""){
			var valbox = $HUI.combobox("#GroupName", {
				required: true,
	    	});
			$.messager.alert("��ʾ","��ȫ�鲻��Ϊ��","info");
			return false;
		}
		var active=$("#Active").checkbox('getValue');
		var activeflag="N";
		if(active) activeflag="Y";
		
		var IsInDoc=$("#IsInDoc").checkbox('getValue');
		var IsInDocfalg="N";
		if(IsInDoc) IsInDocfalg="Y";
		
		var EmpowerFlag="N";
		if($("#Empower").checkbox('getValue')) EmpowerFlag="Y";
		
		var flag=tkMakeServerCall("web.DHCPE.CT.ChartAssign","UpdateAssign",UserID,LocID,GroupID,Type,session['LOGON.USERID'],activeflag,IsInDocfalg,"");
		if(flag.split("^")[0]==-1){
			$.messager.alert('��ʾ',"����ʧ�ܣ�"+flag.split("^")[1],'error');
			return false;
		}
		else{
			$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
			BClear_click();
		}
			
	}
	
	if(Type=="2")
	{
		var ID=$("#UserID").val();
		if(ID==""){
			
			$.messager.alert("��ʾ","δѡ������","info");
			return false;
		}
		
	var UserID=$("#UserName").combogrid('getValue');
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
	
	var LocID=$("#LocList").combogrid('getValue');
	if (($("#LocList").combogrid('getValue')==undefined)||($("#LocList").combogrid('getValue')=="")){var LocID="";}
	 if (LocID!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsCTLoc",LocID);
			if(ret=="0"){
				$.messager.alert("��ʾ","��ѡ�����","info");
				return false;
				}
		}else{
			var valbox = $HUI.combogrid("#LocList", {
				required: true,
	    	});
			$.messager.alert("��ʾ","���Ҳ���Ϊ��","info");
			return false;
			
		}
	
	var GroupID=$("#GroupName").combobox('getValue');
	if (($("#GroupName").combobox('getValue')==undefined)||($("#GroupName").combobox('getValue')=="")){var GroupID="";}
	 if (GroupID==""){
			var valbox = $HUI.combobox("#GroupName", {
				required: true,
	    	});
			$.messager.alert("��ʾ","��ȫ�鲻��Ϊ��","info");
			return false;
		}
		var active=$("#Active").checkbox('getValue');
		var activeflag="N";
		if(active) activeflag="Y";
		
		var IsInDoc=$("#IsInDoc").checkbox('getValue');
		var IsInDocfalg="N";
		if(IsInDoc) IsInDocfalg="Y";
		
		var EmpowerFlag="N";
		if($("#Empower").checkbox('getValue')) EmpowerFlag="Y";
		var ChartID=$("#ChartID").val()
		var flag=tkMakeServerCall("web.DHCPE.CT.ChartAssign","UpdateAssign",UserID,LocID,GroupID,Type,session['LOGON.USERID'],activeflag,IsInDocfalg,ChartID);
		if(flag.split("^")[0]==-1){
			$.messager.alert('��ʾ',"�޸�ʧ��"+flag.split("^")[1],'error');
			return false;
		}
		else{
			$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
			BClear_click();
		}
			
	}
	
	
}


function InitChartAssignDataGrid(){
  
    var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
    if(LocListID!=""){var LocID=LocListID; }
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		    
	$HUI.datagrid("#ChartAssignTab",{
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
			ClassName:"web.DHCPE.CT.ChartAssign",
			QueryName:"SerchChartAssign",
			hospId:hospId,
			LocID:LocID
			
		},
		columns:[[
	
		    {field:'TUserID',title:'UserID',hidden: true},
		    {field:'TGroupID',title:'GroupID',hidden: true},
		    {field:'TLocID',title:'LocID',hidden: true},
			{field:'TUserName',width:150,title:'�û�'},
			{field:'TGroupName',width:190,title:'��ȫ��'},
			{field:'TLocName',width:180,title:'����'},
			{field:'Active',width:50,title:'����',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'IsInDoc',width:80,title:'סԺҽ��',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'ChartID',hidden:true}
			
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$('#ChartAssignDetailTab').datagrid('loadData', {
				total: 0,
				rows: []
				});
			
			LoadtChartAssignDetailTablist(rowData);
				
		},
		
			
	})
	 
   
}




/*********************************************����Ȩ��*********************************************/
function LoadtChartAssignDetailTablist(rowData){
	//debugger; // 1
	$("#ChartAssignDetailTab").datagrid('load', {
			ClassName:"web.DHCPE.CT.ChartAssign",
			QueryName:"SerchChartDetail",
			ChartID:rowData.ChartID,
			LocID:$("#LocList").combobox('getValue')
		
	});
	//debugger; //2
	//alert(2)
	console.log(rowData.TUserName.split("(")[0])
	$("#UserName").combogrid("grid").datagrid("reload",{"q":rowData.TUserName.split("(")[0]});
	console.log(rowData.TUserID)
	
	$("#UserName").combogrid('setValue',rowData.TUserID);
	
	//$("#GroupName").combobox("grid").datagrid("reload",{"q":rowData.TGroupName});
	$("#GroupName").combobox('setValue',rowData.TGroupID);
	//debugger; // 3
	
	$("#UserID").val(rowData.TUserID);
	$("#GroupID").val(rowData.TGroupID);
	$("#LocID").val(rowData.TLocID);
	$("#ChartID").val(rowData.ChartID);
	if(rowData.Active=="Y"){ $("#Active").checkbox('setValue',true); }
	else{$("#Active").checkbox('setValue',false); }
	if(rowData.IsInDoc=="Y"){ $("#IsInDoc").checkbox('setValue',true); }
	else{$("#IsInDoc").checkbox('setValue',false); }

}

function InitChartAssignDetailDataGrid()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
    if(LocListID!=""){var LocID=LocListID; }
	

	$HUI.datagrid("#ChartAssignDetailTab",{
		url:$URL,
		fit : true,
		border : false,
		striped: true, //�Ƿ���ʾ������Ч��
		fitColumns:true,
		autoRowHeight: false,
		showFooter: true,
		singleSelect:true,
		//singleSelect: false,
		//checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		//selectOnCheck: false,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		pageSize: 100,
		pageList: [100,200],
		queryParams:{
			ClassName:"web.DHCPE.CT.ChartAssign",
			QueryName:"SerchChartDetail",
			LocID:LocID
		},
        onClickRow: onClickRow,
		onLoadSuccess:function(data){
			editIndex = undefined;
		},
		columns:[[
		    {field:'TChartID',title:'ChartID',hidden: true},
			{field:'TChartName',width:120,title:'Ȩ������'},
			
			{field:'TUseFlag',width:40,align:'center',title:'�ɶ�',
				formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
					editor:{type:'checkbox',options:{on:'Y',off:'N'}}
			},
			{field:'TWrite',width:40,align:'center',title:'��д',
				formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
                  
					editor:{type:'checkbox',options:{on:'Y',off:'N'}}
			},
			{field:'TDefault',width:40,align:'center',title:'Ĭ��',
				formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
					editor:{type:'checkbox',options:{on:'Y',off:'N'}}
			},
			{field:'TWriteWay', width:90,title:'���ҷ���',
			    	formatter:comboboxFormatter,
	                //allowBlank:false,
	                editor:{
						type:'combobox',
						options:{
							valueField:'id',
							textField:'name',
							data:[
							{id:'1',name:'�ֶ�ȷ��'},
							{id:'2',name:'������'},
							{id:'3',name:'�����ύ'},
							{id:'4',name:'��ȷ��'}
							],                            
                    	//required:true
                    	}
					}
			}
		
		]],
			
	})
}




//����	
function BSave_Click(){

	var UserId=session['LOGON.USERID'];
    $('#ChartAssignDetailTab').datagrid('endEdit', editIndex); //���һ�н����б༭	
	
	$.messager.confirm('ȷ��','ȷ��Ҫ����������',function(t){
		    	if(t){
			    	
	            	//var rows = $('#ChartAssignDetailTab').datagrid("getChanges");
	            	var rows = $('#ChartAssignDetailTab').datagrid("getRows");
                	if(rows.length>0){
	                		
	                		var str="";
	                		for(var i=0; i<rows.length; i++){
	              
	                			var chartID=rows[i].TChartID;
	                			//var useFlag=rows[i].TUseFlag;
	                			var useFlag=getColumnValue(i,"TUseFlag","ChartAssignDetailTab");
	                			//var WriteFlag=rows[i].TWrite;
	                			if(useFlag=="1"){var useFlag="Y"}
	                			if(useFlag=="0"){var useFlag="N"}
	                		
		                		var WriteFlag=getColumnValue(i,"TWrite","ChartAssignDetailTab");
	                			if(WriteFlag=="1"){var WriteFlag="Y"}
	                			if(WriteFlag=="0"){var WriteFlag="N"}
	                			
	                			var DefaultFlag=getColumnValue(i,"TDefault","ChartAssignDetailTab");
	                			if(DefaultFlag=="1"){var DefaultFlag="Y"}
	                			if(DefaultFlag=="0"){var DefaultFlag="N"}
	                			var WriteWay=rows[i].TWriteWay;
	                			
	                			//if (DefaultFlag=="Y") DefaultNum=DefaultNum+1;
	                			//debugger; //
								if (str==""){
									str=chartID+"$"+useFlag+"$"+WriteFlag+"$"+DefaultFlag+"$"+WriteWay;
								}else{
									str=str+"^"+chartID+"$"+useFlag+"$"+WriteFlag+"$"+DefaultFlag+"$"+WriteWay;
								} 
								
	                		}
	                	var DefaultNum=0;
	                	var rrows = $('#ChartAssignDetailTab').datagrid("getRows");
	                	for(var i=0;i<rrows.length;i++){
		                	var DefaultFlag=rrows[i].TDefault;
		                	var DefaultFlag=getColumnValue(i,"TDefault","ChartAssignDetailTab");
	                			
		                	//alert(DefaultFlag)
		                	if (DefaultFlag=="1") DefaultNum=DefaultNum+1;
		                
	                	}
	                	if (DefaultNum>1){
		                		$.messager.alert("��ʾ","Ĭ��վ��ֻ��ѡ��һ��","info");
								return false;
							}

    
						var  UserID=$("#UserID").val();
						if (UserID==""){
								$.messager.alert("��ʾ","����Ա����Ϊ��","info");
								return false;
							}
						var  LocID=$("#LocID").val();
						if (LocID==""){
							   $.messager.alert("��ʾ","���Ҳ���Ϊ��","info");
								return false;
							}
						var  GroupID=$("#GroupID").val();
						if (GroupID==""){
							    $.messager.alert("��ʾ","��ȫ�鲻��Ϊ��","info");
								return false;
							}
						//alert(UserID+"^"+LocID+"^"+GroupID+"^"+str)
						var ChartID=$("#ChartID").val();
						if(ChartID==""){
							$.messager.alert("��ʾ","δѡ������","info")
							}
						
						var flag=tkMakeServerCall("web.DHCPE.CT.ChartAssign","UpdateAssignDetail",ChartID,str,UserId);
                         if(flag.split("^")[0]=="0"){
	                           $.messager.popover({msg: flag.split("^")[1],type:'success',timeout: 1000});
	                            $("#ChartAssignDetailTab").datagrid('load',{
								ClassName:"web.DHCPE.CT.ChartAssign",
								QueryName:"SerchChartDetail",
								ChartID:$("#ChartID").val(),
								LocID:$("#LocList").combobox('getValue')
	        
							});
                           }
                         else{
	                         $.messager.alert("��ʾ",flag.split("^")[1],"error");  
                         }
                		}
             
               			
		    		}
	});
	
		    	
	
}


	//combox����value��ѡ����ȷ��textFieldֵ,�ʺ�comboxֵ�Ƚ��ٵ����
  		function  comboboxFormatter (value, row, rowIndex){
	  		if (!value){
		  		return value;
		  	}
		  	var e = this.editor;
		  	if(e && e.options && e.options.data){
			  	var values = e.options.data;
			  	for (var i = values.length - 1; i >= 0; i--) {
				  	//0 {k: "1", v: "test"}
				  	var k = values[i]['id'];
				  	if (value == k ){
					  	//����Vֵ
					  	return values[i]['name'];
					}
					// ����float�����ֶΣ�ת������ȡ�����ٱȽ�
					else if (!isNaN(k) && !isNaN(value) && Math.floor(parseFloat(k))===Math.floor(parseFloat(value)) ) {
						return values[i]['id'];
					}
				}
			}
		}  
		


//�б�༭
var editIndex = undefined;

//�����б༭
function endEditing(){
			
	if (editIndex == undefined){return true}
	if ($('#ChartAssignDetailTab').datagrid('validateRow', editIndex)){
				
			$('#ChartAssignDetailTab').datagrid('endEdit', editIndex);	
			editIndex = undefined;
				return true;
			} else {
				return false;			}

	}

//���ĳ�н��б༭
function onClickRow(index,field,value){
	
if (editIndex!=index) {
			if (endEditing()){
					$('#ChartAssignDetailTab').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
					editIndex = index;
					
			} else {
				$('#ChartAssignDetailTab').datagrid('selectRow', editIndex);
			}
			
		
		}

	}
	

		
		

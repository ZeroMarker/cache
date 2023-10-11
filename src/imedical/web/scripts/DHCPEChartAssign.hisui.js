
//����	DHCPEChartAssign.hisui.js
//����	���ҽ��Ȩ�޹���
//����	2019.06.04
//������  xy

$(function(){
		
	InitCombobox();
	
	InitChartAssignDataGrid();
    
    InitChartAssignDetailDataGrid(); 
    
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
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
	alert(value+"^"+rowIndex)
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
	 //����Ա
	   var OPNameObj = $HUI.combogrid("#UserName",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:40},
			{field:'DocName',title:'����',width:200},
			{field:'Initials',title:'����',width:200}	
				
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',""); 
		}

		});	
		 
		//����
		var LocObj = $HUI.combogrid("#LocName",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest",
		mode:'remote',
		delay:200,
		idField:'CTLOCID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ctlocdesc = param.q;
			param.hospId = session['LOGON.HOSPID'];
		},
		
		columns:[[
			{field:'CTLOCID',hidden:true},
			{field:'CTLOCCODE',title:'���ұ���',width:100},
			{field:'Desc',title:'��������',width:200}	
			
		]],
		onLoadSuccess:function(){
			//$("#LocName").combogrid('setValue',""); 
		}

	});
		
		
	//��ȫ��
	var GroupObj = $HUI.combobox("#GroupName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onBeforeLoad:function(param){
			param.hospId = session['LOGON.HOSPID']; 
		}

	});	
	
	    
 
 }
    
/****************************************�û�����************************************/ 
//��ѯ
function BFind_click(){
	$("#ChartAssignTab").datagrid('load',{
			ClassName:"web.DHCPE.ChartAssign",
			QueryName:"SerchChartAssign",
			UserID:$("#UserName").combogrid('getValue'),
		    GroupID:$("#GroupName").combobox('getValue'),
			LocID:$("#LocName").combogrid('getValue'),
			hospId:session['LOGON.HOSPID']
		    
		});	
} 

//����
function BClear_click(){
	$("#UserName").combogrid('setValue');
	$("#GroupName").combobox('setValue');
	$("#LocName").combogrid('setValue');
	$("#UserID,#GroupID,#LocID").val("");
	var valbox = $HUI.combogrid("#UserName", {
				required: false,
	    	});
	var valbox = $HUI.combobox("#GroupName", {
				required: false,
	    	});
	var valbox = $HUI.combogrid("#LocName", {
				required: false,
	    	});
	$("#ChartAssignTab").datagrid('load',{
			ClassName:"web.DHCPE.ChartAssign",
			QueryName:"SerchChartAssign",
			hospId:session['LOGON.HOSPID']
			
		    
		});	
}

//����
function BAdd_click(){
	Update("0");
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
		//alert(ID+"^"+LocID+"^"+GroupID)
		$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			$.m({ ClassName:"web.DHCPE.ChartAssign", MethodName:"UpdateAssign", UserID:ID,LocID:LocID,GroupID:GroupID,Type:'1'},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
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
	
	var LocID=$("#LocName").combogrid('getValue');
	if (($("#LocName").combogrid('getValue')==undefined)||($("#LocName").combogrid('getValue')=="")){var LocID="";}
	 if (LocID!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsCTLoc",LocID);
			if(ret=="0"){
				$.messager.alert("��ʾ","��ѡ�����","info");
				return false;
				}
		}else{
			var valbox = $HUI.combogrid("#LocName", {
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
		
		var flag=tkMakeServerCall("web.DHCPE.ChartAssign","UpdateAssign",UserID,LocID,GroupID,Type);
		if(flag==0){
		
			$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
			BClear_click();
			
			
		}	
	}
	
	
}


function InitChartAssignDataGrid(){
  
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
			ClassName:"web.DHCPE.ChartAssign",
			QueryName:"SerchChartAssign",
			hospId:session['LOGON.HOSPID']
		},
		columns:[[
	
		    {field:'TUserID',title:'UserID',hidden: true},
		    {field:'TGroupID',title:'GroupID',hidden: true},
		    {field:'TLocID',title:'LocID',hidden: true},
			{field:'TUserName',width:150,title:'�û�'},
			{field:'TGroupName',width:200,title:'��ȫ��'},
			{field:'TLocName',width:200,title:'����'},
		
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
	
	$("#ChartAssignDetailTab").datagrid('load', {
			ClassName:"web.DHCPE.ChartAssign",
			QueryName:"SerchChartDetail",
			UserID:rowData.TUserID,
			GroupID:rowData.TGroupID,
			LocID:rowData.TLocID,
		
	});
	$("#UserID").val(rowData.TUserID);
	$("#GroupID").val(rowData.TGroupID);
	$("#LocID").val(rowData.TLocID);

}

function InitChartAssignDetailDataGrid()
{
	
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
			ClassName:"web.DHCPE.ChartAssign",
			QueryName:"SerchChartDetail",
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
						if(value=="1"){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
					editor:{type:'checkbox',options:{on:'1',off:'0'}}
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


    $('#ChartAssignDetailTab').datagrid('endEdit', editIndex); //���һ�н����б༭	
	
	/*if($('#ChartAssignDetailTab').datagrid("getChanges").length==0){
		
				$.messager.alert("��ʾ","û����Ҫ����ļ�¼","info");
			     return;
	}
	*/

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
	                		
		                		var WriteFlag=getColumnValue(i,"TWrite","ChartAssignDetailTab");
	                			if(WriteFlag=="1"){var WriteFlag="Y"}
	                			if(WriteFlag=="0"){var WriteFlag="N"}
	                			
	                			var DefaultFlag=rows[i].TDefault;
	                			var WriteWay=rows[i].TWriteWay;
	                			
	                			//if (DefaultFlag=="Y") DefaultNum=DefaultNum+1;
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
		                	//alert(DefaultFlag)
		                	if (DefaultFlag=="Y") DefaultNum=DefaultNum+1;
		                
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
						var flag=tkMakeServerCall("web.DHCPE.ChartAssign","UpdateAssignDetail",UserID,LocID,GroupID,str);
                         //alert(flag)
                        if(flag=="0"){
	                            $.messager.alert("��ʾ","����ɹ�","success");
	                            $("#ChartAssignDetailTab").datagrid('load',{
								ClassName:"web.DHCPE.ChartAssign",
								QueryName:"SerchChartDetail",
								UserID:$("#UserID").val(),
								GroupID:$("#GroupID").val(),
								LocID:$("#LocID").val(),
	        
							});
                           }
                         else{
	                         $.messager.alert("��ʾ","����ʧ��","error");  
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
	

		
		

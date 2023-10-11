
//名称	DHCPEChartAssign.hisui.js
//功能	体检医生权限管理
//创建	2019.06.04
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitChartAssignDataGrid();
    
    InitChartAssignDetailDataGrid(); 
    
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
    //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
        
    //修改
    $("#BUpdate").click(function() {	
		BUpdate_click();		
        });
    
         
    //删除
	$("#BDelete").click(function() {	
		BDelete_Click();		
        });
       
        
     //保存
	$("#BSave").click(function() {	
		BSave_Click();		
        });
   
   
   //全选可写
	$('#SelectAllUse').checkbox({
		onCheckChange:function(e,vaule){
			BSelectAllUse_change(vaule);
			
			}
			
	});
   
   
   //全选可读
	$('#SelectAllWrite').checkbox({
		onCheckChange:function(e,vaule){
			BSelectAllWrite_change(vaule);
			
			}
			
	});
   
   
 })
    
 //全选可读
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
   //全选可写
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
	 //操作员
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
			{field:'DocName',title:'姓名',width:200},
			{field:'Initials',title:'工号',width:200}	
				
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',""); 
		}

		});	
		 
		//科室
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
			{field:'CTLOCCODE',title:'科室编码',width:100},
			{field:'Desc',title:'科室名称',width:200}	
			
		]],
		onLoadSuccess:function(){
			//$("#LocName").combogrid('setValue',""); 
		}

	});
		
		
	//安全组
	var GroupObj = $HUI.combobox("#GroupName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onBeforeLoad:function(param){
			param.hospId = session['LOGON.HOSPID']; 
		}

	});	
	
	    
 
 }
    
/****************************************用户管理************************************/ 
//查询
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

//清屏
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

//新增
function BAdd_click(){
	Update("0");
}
  

//删除
function BDelete_Click(){
	Update("1");
	
}

function Update(Type){


	if(Type=="1")
	{
		var ID=$("#UserID").val();
		if(ID==""){
			$.messager.alert("提示","请选择待删除的记录","info");
			return false;
		}
		var LocID=$("#LocID").val();
		var GroupID=$("#GroupID").val();
		//alert(ID+"^"+LocID+"^"+GroupID)
		$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			$.m({ ClassName:"web.DHCPE.ChartAssign", MethodName:"UpdateAssign", UserID:ID,LocID:LocID,GroupID:GroupID,Type:'1'},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
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
			
			$.messager.alert("提示","新增数据不能选中记录,需先清屏再新增","info");
			return false;
		}
		
	var UserID=$("#UserName").combogrid('getValue');
	if (($("#UserName").combogrid('getValue')==undefined)||($("#UserName").combogrid('getValue')=="")){var UserID="";}
	
	if (UserID!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsUser",UserID);
			if(ret=="0"){
				$.messager.alert("提示","请选择用户","info");
				return false;
				}
		}else{
			var valbox = $HUI.combogrid("#UserName", {
				required: true,
	    	});
			$.messager.alert("提示","用户不能为空","info");
			return false;
		}
	
	var LocID=$("#LocName").combogrid('getValue');
	if (($("#LocName").combogrid('getValue')==undefined)||($("#LocName").combogrid('getValue')=="")){var LocID="";}
	 if (LocID!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsCTLoc",LocID);
			if(ret=="0"){
				$.messager.alert("提示","请选择科室","info");
				return false;
				}
		}else{
			var valbox = $HUI.combogrid("#LocName", {
				required: true,
	    	});
			$.messager.alert("提示","科室不能为空","info");
			return false;
			
		}
	
	var GroupID=$("#GroupName").combobox('getValue');
	if (($("#GroupName").combobox('getValue')==undefined)||($("#GroupName").combobox('getValue')=="")){var GroupID="";}
	 if (GroupID==""){
			var valbox = $HUI.combobox("#GroupName", {
				required: true,
	    	});
			$.messager.alert("提示","安全组不能为空","info");
			return false;
		}
		
		var flag=tkMakeServerCall("web.DHCPE.ChartAssign","UpdateAssign",UserID,LocID,GroupID,Type);
		if(flag==0){
		
			$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});
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
			{field:'TUserName',width:150,title:'用户'},
			{field:'TGroupName',width:200,title:'安全组'},
			{field:'TLocName',width:200,title:'科室'},
		
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




/*********************************************操作权限*********************************************/
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
		striped: true, //是否显示斑马线效果
		fitColumns:true,
		autoRowHeight: false,
		showFooter: true,
		singleSelect:true,
		//singleSelect: false,
		//checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		//selectOnCheck: false,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
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
			{field:'TChartName',width:120,title:'权限描述'},
			
			{field:'TUseFlag',width:40,align:'center',title:'可读',
				formatter: function (value, rec, rowIndex) {
						if(value=="1"){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
					editor:{type:'checkbox',options:{on:'1',off:'0'}}
			},
			{field:'TWrite',width:40,align:'center',title:'可写',
				formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
                  
					editor:{type:'checkbox',options:{on:'Y',off:'N'}}
			},
			{field:'TDefault',width:40,align:'center',title:'默认',
				formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
					editor:{type:'checkbox',options:{on:'Y',off:'N'}}
			},
			{field:'TWriteWay', width:90,title:'科室分配',
			    	formatter:comboboxFormatter,
	                //allowBlank:false,
	                editor:{
						type:'combobox',
						options:{
							valueField:'id',
							textField:'name',
							data:[
							{id:'1',name:'手动确认'},
							{id:'2',name:'保存结果'},
							{id:'3',name:'科室提交'},
							{id:'4',name:'不确认'}
							],                            
                    	//required:true
                    	}
					}
			}
		
		]],
			
	})
}




//保存	
function BSave_Click(){


    $('#ChartAssignDetailTab').datagrid('endEdit', editIndex); //最后一行结束行编辑	
	
	/*if($('#ChartAssignDetailTab').datagrid("getChanges").length==0){
		
				$.messager.alert("提示","没有需要保存的记录","info");
			     return;
	}
	*/

	$.messager.confirm('确定','确定要保存数据吗？',function(t){
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
		                		$.messager.alert("提示","默认站点只能选择一个","info");
								return false;
							}

    
						var  UserID=$("#UserID").val();
						if (UserID==""){
								$.messager.alert("提示","操作员不能为空","info");
								return false;
							}
						var  LocID=$("#LocID").val();
						if (LocID==""){
							   $.messager.alert("提示","科室不能为空","info");
								return false;
							}
						var  GroupID=$("#GroupID").val();
						if (GroupID==""){
							    $.messager.alert("提示","安全组不能为空","info");
								return false;
							}
						//alert(UserID+"^"+LocID+"^"+GroupID+"^"+str)
						var flag=tkMakeServerCall("web.DHCPE.ChartAssign","UpdateAssignDetail",UserID,LocID,GroupID,str);
                         //alert(flag)
                        if(flag=="0"){
	                            $.messager.alert("提示","保存成功","success");
	                            $("#ChartAssignDetailTab").datagrid('load',{
								ClassName:"web.DHCPE.ChartAssign",
								QueryName:"SerchChartDetail",
								UserID:$("#UserID").val(),
								GroupID:$("#GroupID").val(),
								LocID:$("#LocID").val(),
	        
							});
                           }
                         else{
	                         $.messager.alert("提示","保存失败","error");  
                         }
                		}
             
               			
		    		}
	});
	
		    	
	
}


	//combox根据value来选择正确的textField值,适合combox值比较少的情况
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
					  	//返回V值
					  	return values[i]['name'];
					}
					// 对于float类型字段，转换成数取整，再比较
					else if (!isNaN(k) && !isNaN(value) && Math.floor(parseFloat(k))===Math.floor(parseFloat(value)) ) {
						return values[i]['id'];
					}
				}
			}
		}  
		


//列表编辑
var editIndex = undefined;

//结束行编辑
function endEditing(){
			
	if (editIndex == undefined){return true}
	if ($('#ChartAssignDetailTab').datagrid('validateRow', editIndex)){
				
			$('#ChartAssignDetailTab').datagrid('endEdit', editIndex);	
			editIndex = undefined;
				return true;
			} else {
				return false;			}

	}

//点击某行进行编辑
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
	

		
		

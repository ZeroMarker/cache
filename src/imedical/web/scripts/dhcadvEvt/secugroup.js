///CreatDate：   2017-12-10 
///Creator：    huaxiaoying
var EditRow="0";   //add by sufan 2018-07-16
var hospID="";
$(function(){ 
    //初始化医院 多院区改造 cy 2021-04-09
    InitHosp(); 
	//初始化界面默认信息
	InitDefault();
	
});
function InitHosp(){
	hospComp = GenHospComp("DHC_AdvSecuGroup"); 
	hospID=hospComp.getValue();
	//hospComp.setValue("全部"); 
	//$HUI.combogrid('#_HospList',{value:"11"})
	hospComp.options().onSelect = function(){///选中事件
 		hospID=hospComp.getValue();
		QueryBtn();
	}
}

function InitDefault(){ 
	$.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
					
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
	
	//同时给代码和描述绑定回车事件
     $('#SECUCode,#SECUDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
        }
    });
    $('#WardW,#UserW,#LocW').window('close');  //2018-01-12 cy 添加分管科室
	loadHtml();
	QueryBtn();
	
};

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'SECUActiveFlag':'Y','SECUHospDr':hospID}})
}
//双击编辑
function onDblClickRow(index,row){
	EditRow=index;
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCADVSecuGroup","SaveSecuGro","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==2){
				$.messager.alert("提示","数据已被工作流使用，不能修改数据是否可用性!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
}

///删除成员
function deleteUser(id){
	//alert(id)
	$.messager.confirm('确认','您确认想要删除该成员吗？',function(r){    
    	if (r){   
		 runClassMethod("web.DHCADVSecuGroup","RemoveSecuGroU",{'Id':id},function(data){ 
		 	reloadHtml();///重新加载关联表格 
		 })
    	}  
    });
}
///删除病区
function deleteWard(id){
	$.messager.confirm('确认','您确认想要删除该病区吗？',function(r){    
    	if (r){   
		 runClassMethod("web.DHCADVSecuGroup","RemoveSecuGroUW",{'Id':id},function(data){ 
		 	reloadHtml();///重新加载关联表格 
		 })
    	}  
	});
}
///添加安全小组成员
function addUser(){
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请先选择 安全小组字典表');
		return;
	}
	if($("#datagrid").datagrid('getSelected').ID==undefined){ //hxy 2020-03-19 st
		$.messager.alert('提示','请先选择有效 安全小组字典表 记录');
		return;
	} //ed
	$("#datagrid").datagrid('endEdit', EditRow); 
	$('#UserW').panel({title: "新增小组成员"});
	$('#UserW').window('open');
    $('#gridUser').datagrid('loadData',{total:0,rows:[]});
	addUserAdd();
	/*var row =$("#datagrid").datagrid('getSelected');
	SECURowId=row.ID; ///子表id
	commonAddRow({'datagrid':'#gridUser',value:{'SECUGrpDr':SECURowId,'SECULeadFlag':'N'}})
    var rowIndex=$('#gridUser').datagrid('getRowIndex',$('#gridUser').datagrid('getSelected'))
	var varEditor = $('#gridUser').datagrid('getEditor', { index: rowIndex, field: 'SECUUser' });
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListUser&HospDr='+LgHospID
	})	*/
}
//双击编辑成员
function onDblClickRowUser(index,row){
	CommonRowClick(index,row,"#gridUser");
	var varEditor = $('#gridUser').datagrid('getEditor', { index: index, field: 'SECUUser' });
	$(varEditor.target).combogrid({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListUser&SECURowId='+SECURowId+'&HospID='+hospID
	})
		$(varEditor.target).combogrid('setValue',row.SECUUser);
}
///添加安全小组成员-增加
function addUserAdd(){
	var row =$("#datagrid").datagrid('getSelected');
	SECURowId=row.ID; ///子表id
	commonAddRow({'datagrid':'#gridUser',value:{'SECUGrpDr':SECURowId,'SECULeadFlag':'N'}})
    var rowIndex=$('#gridUser').datagrid('getRowIndex',$('#gridUser').datagrid('getSelected'))
	var varEditor = $('#gridUser').datagrid('getEditor', { index: rowIndex, field: 'SECUUser' });
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListUser&SECURowId='+SECURowId+'&HospID='+hospID
	})	
}
///修改成员
function updateUser(id){
	var row =$("#datagrid").datagrid('getSelected');
	SECURowId=row.ID; ///子表id
		$('#UserW').panel({title: "修改小组成员"});
		$('#UserW').window('open');	
	$('#gridUser').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=selUser&id='+id
	});			
}
///添加人员
function fillValue(rowIndex, rowData){
	$('#gridUser').datagrid('getRows')[editIndex]['SECUUserDr']=rowData.id;
}
///保存安全小组成员
function saveSecuGU(){
	saveByDataGrid("web.DHCADVSecuGroup","saveSecuGU","#gridUser",function(data){
		if(data==0){
			$('#UserW').window('close');
			reloadHtml();
			$.messager.alert("提示","保存成功!");
			//$("#gridUser").datagrid('load')
		}else if(data==1){
			$.messager.alert("提示","已存在,不能重复保存!"); 
			//$("#gridUser").datagrid('load')
		}else if(data==2){
			$.messager.alert("提示","手动录入无效,请选择!"); 
			//$("#gridUser").datagrid('load')
		}else if(data==3){ //huaxiaoying 2018-02-07
			$.messager.alert("提示","只允许存在一个组长!"); 
		}else{	
			$.messager.alert('提示','保存失败:'+data)
			
		}
	});	
}

///添加安全小组分管病区
function addWard(Drs){
	$('#WardW').window('open');	
	$("#Drs").val(Drs);
	$('#gridWard').datagrid('loadData',{total:0,rows:[]});
	addWardAdd();	
}
///添加安全小组成员病区-增加
function addWardAdd(){
	var Drs=$("#Drs").val();
	$("#datagrid").datagrid('endEdit', EditRow); 
	commonAddRow({'datagrid':'#gridWard',value:{'SECUDrs':Drs}})
    var rowIndex=$('#gridWard').datagrid('getRowIndex',$('#gridWard').datagrid('getSelected'))
	var varEditor = $('#gridWard').datagrid('getEditor', { index: rowIndex, field: 'SECUWard' });
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListWard&HospID='+hospID
	})
	
}
///添加病区
function fillValueWard(rowIndex, rowData){
	$('#gridWard').datagrid('getRows')[editIndex]['SECUWardDr']=rowData.id
}
//双击编辑病区
function onDblClickRowWard(index,row){
	
	CommonRowClick(index,row,"#gridWard");
	var rowIndex=$('#gridWard').datagrid('getRowIndex',$('#gridWard').datagrid('getSelected'))
	var varEditor = $('#gridWard').datagrid('getEditor', { index: index, field: 'SECUWard' });
	var WardText=varEditor.oldHtml;
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListWard&HospID='+hospID
	})
	$(varEditor.target).combogrid("setValue", WardText); 
}
///保存安全小组分管病区
function saveSecuGUW(){
	saveByDataGrid("web.DHCADVSecuGroup","saveSecuGUW","#gridWard",function(data){
		if(data==0){
			$('#WardW').window('close');
			reloadHtml();
			$.messager.alert("提示","保存成功!");
		}else if(data==1){
			$.messager.alert("提示","已存在,不能重复保存!"); 
		}else if(data==2){
			$.messager.alert("提示","手动录入无效,请选择!"); 
		}else{	
			$.messager.alert('提示','保存失败:'+data)
			
		}
	});	

	
}

function onClickRow(index,row){
	var row =$("#datagrid").datagrid('getSelected'); 
	toHtml(row.ID);    
    //var LinkUrl = "dhcadv.secugroupuser.csp?Id="+row.ID;
	//$("#TabMain").attr("src", LinkUrl);
}
///初始化显示右侧
function loadHtml(){	
	var html=""
	$("#itemList").html(""); //hxy 2020-03-19
   // html+='<table id=""  border="1" style="width:640px" cellspacing="0" cellpadding="1" class="form-table" headerCls="panel-header-gray">'
    
    //html+='<thead>'
    //html+='<tr>'
	//html+='	<td width=30>删除成员</td><td width=60>安全小组成员</td><td>分管病区</td><td style="width:60px">添加病区</td><td>分管科室</td><td style="width:60px">添加科室</td><td width=40>组长</td>'  //2018-01-12 cy 添加分管科室
    //html+='</tr>'
   // html+='</thead>'
   // html+='</table>';
   // $("#itemList").html("");
   // $("#itemList").append(html);
}
///重载html
function reloadHtml(){
	var row =$("#datagrid").datagrid('getSelected'); 
	toHtml(row.ID);    
}
///生成html
function toHtml(Id){
    var html=""
    //html+='<table id=""  border="1" style="width:640px" cellspacing="0" cellpadding="1" class="form-table">'
   // html+='<thead style="position:absolute;background:#CCCCCC;">'
   // html+='<tr>'
	//html+='	<td width=30>删除成员</td><td width=60>安全小组成员</td><td>分管病区</td><td style="width:60px">添加病区</td><td>分管科室</td><td style="width:60px">添加科室</td><td width=40>组长</td>'      //2018-01-12 cy 添加分管科室
   // html+='</tr>'
	//html+='</thead>'
	runClassMethod("web.DHCADVSecuGroup","ToHtml",
		{'GrpDr':Id},
		 function(data){
			 var strArray=data.split("!!");
			 for (var i=0;i<strArray.length-1;i++)
			 {
				var trStr=strArray[i];
				if(trStr==undefined){return;}
				var trArray=trStr.split("^");
				html+='<tr>';
				html+='<td style="width:25px;"><a id="'+trArray[0]+'"  class="img icon-cancel" onclick="deleteUser(this.id)" title="删除"></a></td>';
			    html+='<td style="width:50px;max-width:50px;" ondblclick="updateUser('+trArray[0]+')">'+trArray[1]+'</td>' //hxy 2020-03-19 max-width:50px;
				
				html+='<td style="width:150px;">'
				if(trArray==""){wardHtml=""}
				var wardHtml=""
				if(trArray[4]==""){
					wardHtml=""
				}else{
					var GUWArray=trArray[4].split("||");
					for (var j=0;j<GUWArray.length-1;j++)
					{
						var WardStr=GUWArray[j];
						var tdArray=WardStr.split("*");
						if(j>0){
							wardHtml+='<br style="line-height:28px">';	
						}
			        	wardHtml+='<div style="float:left">';		
			        	wardHtml+='	<span id="'+tdArray[0]+'" class="img icon-no" onclick="deleteWard(this.id)" style="float:left" title="删除"></span><span class="warditm">'+tdArray[1]+'</span>';				
						wardHtml+='</div>';	
						
					}
				}
				html+=wardHtml
				html+='</td>'
				//2018-01-12 cy 添加分管科室
				html+='<td style="width:25px;"><a id="'+trArray[3]+'" class="img icon-add" onclick="addWard(this.id)" title="新增"></a></td>';
				
				html+='<td style="width:150px;">'
				if(trArray==""){LocHtml=""}
				var LocHtml=""
				if(trArray[5]==""){
					LocHtml=""
				}else{
					var GULArray=trArray[5].split("||");
					for (var j=0;j<GULArray.length-1;j++)
					{
						var LocStr=GULArray[j];
						var tdArray=LocStr.split("*");
						if(j>0){
							LocHtml+='<br style="line-height:28px">';	
						}
			        	LocHtml+='<div style="float:left">';		
			        	LocHtml+='	<span id="'+tdArray[0]+'" class="img icon-no" onclick="deleteLoc(this.id)" style="float:left" title="删除"></span><span class="Locitm">'+tdArray[1]+'</span>';				
						
						LocHtml+='</div>';	
					}
				}
				html+=LocHtml
				html+='</td>'
				html+='<td style="width:25px;"><a id="'+trArray[3]+'" class="img icon-add" onclick="addLoc(this.id)" title="新增"></a></td>';
				if(trArray[2]=="N"){
			        html+='<td style="width:25px;"><input id="'+trArray[0]+'" class="checkbox" type="checkbox" name="" value="Y" onclick="updateLeadFlag(this)"></input></td>';	 //hxy 2018-02-07
			    }else{
					html+='<td style="width:25px;"><input id="'+trArray[0]+'" class="checkbox" type="checkbox" name="" value="N" checked onclick="updateLeadFlag(this)"></input></td>';	 //hxy 2018-02-07
				}  
				html+='</tr>';
			 }//第一个for循环结束
	 	    // html+='</table>';
	 	     $("#itemList").html("");
	         $("#itemList").append(html);
	});


}

///huaxiaoying 2018-02-07 右侧组长的checkbox调用更新数据
function updateLeadFlag(option){
	runClassMethod("web.DHCADVSecuGroup","UpdateGUByLeadFlag",{'Id':option.id,'LeadFlag':option.value},function(data){ 
		if(data==3){
			$.messager.alert('提示','只允许存在一个组长!');
		}
		reloadHtml();
	})
	
}

function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	if($("#datagrid").datagrid('getSelected').ID==undefined){ //hxy 2020-03-19 st
		$("#datagrid").datagrid('deleteRow', EditRow);
		return;
	} //ed
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCADVSecuGroup","RemoveSecuGro",{'Id':row.ID},function(data){ 
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$('#datagrid').datagrid('load');
		 		loadHtml();
			}else if(data=="-2"){
				$.messager.alert('提示','该数据被工作流引用，不能删除');
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
			}
		 	 
		 })
    }    
});
}

///分管科室 相关程序  cy  2018-01-12 
///添加安全小组分管科室
function addLoc(LocDrs){
	$('#LocW').window('open');	
	$("#LocDrs").val(LocDrs);
	$('#gridLoc').datagrid('loadData',{total:0,rows:[]});
	addLocAdd();	
}
///添加安全小组成员科室-增加
function addLocAdd(){
	var LocDrs=$("#LocDrs").val();
	$("#datagrid").datagrid('endEdit', EditRow); 
	commonAddRow({'datagrid':'#gridLoc',value:{'SECUGULDrs':LocDrs}})
    var rowIndex=$('#gridLoc').datagrid('getRowIndex',$('#gridLoc').datagrid('getSelected'))
	var varEditor = $('#gridLoc').datagrid('getEditor', { index: rowIndex, field: 'SECUGULLoc' });
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListLoc&HospID='+hospID
	})
	
}
///添加科室
function fillValueLoc(rowIndex, rowData){
	$('#gridLoc').datagrid('getRows')[editIndex]['SECUGULLocDr']=rowData.id

}

//双击编辑科室
function onDblClickRowLoc(index,row){
	CommonRowClick(index,row,"#gridLoc");
	var rowIndex=$('#gridLoc').datagrid('getRowIndex',$('#gridLoc').datagrid('getSelected'))
	var varEditor = $('#gridLoc').datagrid('getEditor', { index: rowIndex, field: 'SECUGULLoc' });
	var LocText=varEditor.oldHtml;
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSecuGroup&MethodName=ListLoc&HospID='+hospID
	})
	$(varEditor.target).combogrid("setValue", LocText); 
	
	
}
///保存安全小组分管科室
function saveSecuGUL(){
	saveByDataGrid("web.DHCADVSecuGroup","saveSecuGUL","#gridLoc",function(data){
		if(data==0){
			$('#LocW').window('close');
			reloadHtml();
			$.messager.alert("提示","保存成功!");
		}else if(data==1){
			$.messager.alert("提示","已存在,不能重复保存!"); 
		}else if(data==2){
			$.messager.alert("提示","手动录入无效,请选择!"); 
		}else{	
			$.messager.alert('提示','保存失败:'+data)
			
		}
	});	
	
}
///删除病区
function deleteLoc(id){
	$.messager.confirm('确认','您确认想要删除该科室吗？',function(r){    
    	if (r){   
		 runClassMethod("web.DHCADVSecuGroup","RemoveSecuGroUL",{'Id':id},function(data){ 
		 	reloadHtml();///重新加载关联表格 
		 })
    	}  
	});
}
///2018-02-01 cy 增加查询按钮,重置按钮链接方法,
function QueryBtn(){
	commonQuery({'datagrid':'#datagrid','formid':'#queryForm'});
	loadHtml();
}
function ReloadBtn(){
	commonReload({'datagrid':'#datagrid','formid':'#queryForm'})
	loadHtml();
}
//删除病区列表  sufan 2018-05-22
function cancelWard()
{
	var select=$('#gridWard').datagrid('getSelected');
	if(select == null){
		$.messager.alert('提示','请选择');
		return false;
	}
	var index=$('#gridWard').datagrid('getRowIndex',select);
	$.messager.confirm('确认','您确认想要删除该病区吗？',function(r){    
    	if (r){   
		$('#gridWard').datagrid('deleteRow',index);
    	}  
	});
	
}
//删除科室列表  sufan 2018-05-22
function cancelLoc()
{
	var select=$('#gridLoc').datagrid('getSelected');
	if(select == null){
		$.messager.alert('提示','请选择');
		return false;
	}
	var index=$('#gridLoc').datagrid('getRowIndex',select);
	$.messager.confirm('确认','您确认想要删除该科室吗？',function(r){    
    	if (r){   
		$('#gridLoc').datagrid('deleteRow',index);
    	}  
	});
	
}

///CreatDate:  2016-06-07
///Author:    huaxiaoying 
var SAtypeID="";//全局变量：产品功能授权表(孙表)的类型id
var HospDr="";//全局变量：产品表(父表)的医院id
//var SAId=""//全局变量:父表id
var editRowF=0//全局变量：父表双击编辑index //add hxy 2016-08-06
var editRow=0//全局变量：子表双击编辑index //add hxy 2016-08-06
var SId=getParam("SAAId"); //add liyarong
///add liyarong 按下shift+q弹出授权类型窗口
 $(document).keypress(function(event){ 
    if(event.shiftKey && event.keyCode==81){
	     addSecFlag(); 
		  var row =$("#datagrid1").datagrid('getSelected');
	      runClassMethod("web.DHCEMSysItmAut","QuerySecFlag",{"SID":row.ID},function(jsonString){
              	if (jsonString != null){
	              	var sysObj = jsonString;
	              	var sysFlagsArr = sysObj.secflags.split("#")
	              	for (var i=0;i<sysFlagsArr.length;i++){
		              $(window.frames["sysIframe"].document).find('input[name="secflag"][value="'+sysFlagsArr[i]+'"]').attr("checked","checked") ;
		              	}   
	              	}      
		  	});  
	  }
  });

$(function(){
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
	
	$.extend($.fn.datagrid.defaults.editors,{ //huaxiaoying 2018-02-06 st 密码编辑时的加密
	      password: {//datetimebox就是你要自定义editor的名称
	         init: function(container, options){
		        var row =$("#datagrid1").datagrid('getSelected');
				var inputType="text";
				if(row.SYCode.indexOf("PASSWORD")!=-1){
					inputType="password";
				}
	             var input = $('<input style="border:none;width:100%" type="'+inputType+'" class="textbox">').appendTo(container);
	             return input
	         },
	         getValue: function(target){
	             return $(target).val();
	        },
	         setValue: function(target, value){
	             $(target).val(value);
	         },
	         resize: function(target, width){
	         }
	     }
	});
	
	//标识绑定回车事件
     $('#SYGroupName').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
        }
    });
	    //add  liyarong 保存授权类型
         $("#saveBtn").on('click',function(){
	         saveSecFlag();  	     
	     });
     
    $('#SAHospDrID').combobox({ //hxy 2019-07-18 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 
	 $('#queryBTN').on('click',function(){
		 commonQuery({'datagrid':'#datagrid2','formid':'#toolbar2'}); //调用查询
	 }) //hxy ed
   
});
//保存授权类型  add liyarong 2017-03-01
function saveSecFlag(){
	
	var secflags ="";
	$("input[name='secflag']:checked").each(function(){
		secflags+=this.value+"#";

	});	
    var param=secflags+"$"+SId;	
    runClassMethod("web.DHCEMSysItm","updFlag",{'params':param},function(data){ 
		if(data==0){
			parent.$.messager.alert('提示',"保存成功");	
			$("#datagrid").datagrid('load')
			$("#datagrid2").datagrid('load')
			parent.$("#sysWin").window('close');		
		}else{
			if(data="null"){
				parent.$.messager.alert('提示',"未选类型保存失败");
		    }else{
			    parent.$.messager.alert('提示',"保存失败");
			    parent.$("#sysWin").window('close');
			   }	
			}
		
		  });
    	
	}

/// 新增可授权标识
function addSecFlag(){
		if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请先选择 产品表');
		return;
	 }
	   if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请先选择 产品功能表');
		return;
	   }
	  var row =$("#datagrid1").datagrid('getSelected');
	  if(row){
        $('#sysWin').window({
             title:'授权类型',
             collapsible:true,
             border:true,
             closed:'true',
             width:'220',
             height:300
        });
      
      var iframe='<iframe scrolling="yes" width=100% height=100%  id="sysIframe" frameborder="0" src="dhcem.sysWin.csp?SAAId='+row.ID+'"></iframe>';   
      $('#sysWin').html(iframe);       
      $('#sysWin').window('open');   
     
			}    
	}


///csp中孙表类型值调用
function fillValue(rowIndex, rowData){
	$('#datagrid2').datagrid('getRows')[editIndex]['SAPointer']=rowData.id
}

///新增行 产品表(父表) 
function addRowSys(){
	commonAddRow({'datagrid':'#datagrid',value:{'SYActiveFlag':'Y'}}) //hxy 2019-06-21 孙表即可区分医院（用不到的去掉）,'SYHospDr':'2'
}
///双击编辑 产品表(父表) 
function onClickRowSys(index,row){
	editRowF=index //add hxy 2016-08-06
	CommonRowClick(index,row,"#datagrid");
	$("#Hosp").attr("formatter",row.SYHospDr.HOSPDesc);
}
///单击编辑 产品表(父表) 
function ClickRowSys(){
	var row =$("#datagrid").datagrid('getSelected');
	SAId=row.ID; ///父id
	$('#datagrid1').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItm&MethodName=ListSysItm&SAId='+SAId
	});
	$('#datagrid2').datagrid({  //add hxy 2016-08-06
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListSysItmAutNull'
	});
	}
///保存 产品表(父表) 
function saveSys(){
	saveByDataGrid("web.DHCEMSys","SaveSys","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('load')
				$("#datagrid2").datagrid('load')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('load')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
	$('#datagrid1').datagrid({  //add hxy 2016-08-06
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListSysItmAutNull'
	});
	
}

///删除 产品表(父表) 
function cancelSys(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCEMSys","RemoveSys",{'Id':row.ID},function(data){ 
		 $('#datagrid').datagrid('load');
		 $('#datagrid1').datagrid('load');
		 $('#datagrid2').datagrid('load');
		  })
    }    
}); 
}
///重置按钮功能 //add hxy 2016-08-06
function Reload(){
	$('#SYGroupName').val("");
	commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
//	$('#datagrid').datagrid('load');
	$('#datagrid1').datagrid({  
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListSysItmAutNull'
	});
}

///新增行 产品功能表(子表) 
function addRowSysItm(){
	 if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请先选择 产品表');
		return;
	 }
	 $("#datagrid").datagrid('endEdit', editRowF);//add hxy 2016-08-08
	 var row =$("#datagrid").datagrid('getSelected');
	 SAId=row.ID; ///父id  
	 
	commonAddRow({'datagrid':'#datagrid1',value:{'SYRemark':'','SYParRefDr':SAId}})
}
///双击编辑 产品功能表(子表)
function onClickRowSysItm(index,row){
    editRow=index //add hxy 2016-08-06
    $("#datagrid").datagrid('endEdit', editRowF);//add hxy 2016-08-06
	CommonRowClick(index,row,"#datagrid1");
}
///单击编辑 产品功能表(子表)
function ClickRowSysItm(){
	var row =$("#datagrid1").datagrid('getSelected');
	SAItmId=row.ID; ///子表id
	$('#datagrid2').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListSysItmAut&SAItmId='+SAItmId
	});
	}
///保存 产品功能表(子表)
function saveSysItm(){
	saveByDataGrid("web.DHCEMSysItm","SaveSysItm","#datagrid1",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid1").datagrid('load')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid1").datagrid('load')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});
	$('#datagrid2').datagrid({  //add hxy 2016-08-06
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListSysItmAutNull'
	});
			
}

///删除 产品功能表(子表)
function cancelSysItm(){
	
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid1").datagrid('getSelected');     
		 runClassMethod("web.DHCEMSysItm","RemoveSysItm",{'Id':row.ID},function(data){ 
		 $('#datagrid1').datagrid('load');
		 $('#datagrid2').datagrid('load');
		  })
    }    
}); 
}

///新增行 产品功能授权表(孙表)
function addRowSysItmAut(index){
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请先选择 产品表');
		return;
	 }
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请先选择 产品功能表');
		return;
	 }
    $("#datagrid").datagrid('endEdit', editRowF);//add hxy 2016-08-08
    $("#datagrid1").datagrid('endEdit', editRow);//add hxy 2016-08-08
	var row =$("#datagrid1").datagrid('getSelected');
	SAid=row.ID; ///子表id
	
	var rows =$("#datagrid").datagrid('getSelected');
	HospDr=rows.SYHospDrID; ///父表医院id
	  
	commonAddRow({'datagrid':'#datagrid2',value:{'SAHospDr':LgHospID,'SAParRefDr':SAid}}) //hxy 2019-07-26//,'SAHospDr':HospDr
	//SAtypeID="G";
    
    var rowIndex=$('#datagrid2').datagrid('getRowIndex',$('#datagrid2').datagrid('getSelected'))
	var varEditor = $('#datagrid2').datagrid('getEditor', { index: index, field: 'SAType' });

	$(varEditor.target).combobox( { 
				url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListIsWhich&SID='+SAid

	})
    
    
    
}

///双击编辑 产品功能授权表(孙表)
function onClickRowAut(index,row){
	$("#datagrid").datagrid('endEdit', editRowF);//add hxy 2016-08-08
	$("#datagrid1").datagrid('endEdit', editRow);//add hxy 2016-08-06
	CommonRowClick(index,row,"#datagrid2");
	//$("#Hosp1").attr("formatter",row.SAHospDr.HOSPDesc);
	//return;
	SAtypeID=row.SAType
	var rowIndex=$('#datagrid2').datagrid('getRowIndex',$('#datagrid2').datagrid('getSelected'))
	var varEditor = $('#datagrid2').datagrid('getEditor', { index: rowIndex, field: 'PointerDesc' });

	HospDR=row.SAHospDrID

	//add liyarong
	var varEditor1 = $('#datagrid2').datagrid('getEditor', { index: rowIndex, field: 'SAType' }); 
    var row1 =$("#datagrid1").datagrid('getSelected');
	var SAid=row1.ID; ///子表id
    $(varEditor1.target).combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListIsWhich&SID='+SAid   
	    })

	$(varEditor1.target).combobox('setValue', row.SAType);
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListGroup&type='+SAtypeID+'&HospDr='+HospDR
	})
	$(varEditor.target).combogrid('setValue', row.PointerDesc);
		
}
///保存 产品功能授权表(孙表)
function saveSysItmAut(){
	saveByDataGrid("web.DHCEMSysItmAut","SaveSysItmAut","#datagrid2",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid2").datagrid('load')
			}else if(data==1){
				$.messager.alert("提示","类型值已存在,不能重复保存!"); 
				$("#datagrid2").datagrid('load')
			}else if(data==2){
				$.messager.alert("提示","手动录入无效,请上拉选择!"); 
				$("#datagrid2").datagrid('load')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	

}

///删除 产品功能授权表(孙表)
function cancelSysItmAut(){
	
	if ($("#datagrid2").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid2").datagrid('getSelected');     
		 runClassMethod("web.DHCEMSysItmAut","RemoveSysItmAut",{'Id':row.ID},function(data){ $('#datagrid2').datagrid('load'); })
    }    
}); 
}
///sufan 2019-11-08  加载下拉grid数据
function reloadTypeList()
{
	var typeEditor = $('#datagrid2').datagrid('getEditor', { index: editIndex, field: 'SAType' });
	var SAtypeID=$(typeEditor.target).combobox('getValue');
	var typevalEditor = $('#datagrid2').datagrid('getEditor', { index: editIndex, field: 'PointerDesc' });
	var hospEditor = $('#datagrid2').datagrid('getEditor', { index: editIndex, field: 'SAHospDr' });
	var HospDr=$(hospEditor.target).combobox('getValue');
	var SAtypeID=$(typeEditor.target).combobox('getValue');
	$(typevalEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListGroup&type='+SAtypeID+'&HospDr='+HospDr
    })
}
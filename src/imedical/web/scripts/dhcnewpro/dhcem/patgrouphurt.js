///CreatDate：   2016-11-15 
///Creator：    lvpeng
$(function(){ 
	hospComp = GenHospComp("DHC_EmGroupHurt");  //hxy 2020-05-25 st
    query(); //初始化默认查询
	hospComp.options().onSelect = function(){///选中事件
		query();
	}//ed
	
	//同时给代码和描述绑定回车事件
     $('#GHUCode,#GHUDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
	        $("#GHUHospDrID").val(hospComp.getValue()); //hxy 2020-05-25
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
        }
    });
    
    $('#Active').combobox({
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMPatGroupHurt&MethodName=ListIsActive',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto',
		onLoadSuccess:function(data){
			  if (data.length > 0) {
                 $(this).combobox('select', data[0].value);
			  }
		}
	 })
	 
	 /*$('#hospital').combobox({
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto',
		onLoadSuccess:function(data){
			  if (data.length > 0) {
                 $(this).combobox('select', data[0].value);
			  }
		}
	 })*/ //hxy 2020-05-25 注释
	 
	 /*$('#GHUHospDrID').combobox({ //hxy 2019-07-17
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 })*/ //hxy 2020-05-25 注释
});

function addRow(){
	var HospDr=hospComp.getValue(); //hxy 2020-05-25
	commonAddRow({'datagrid':'#datagrid',value:{'GHUActiveFlag':'Y','GHUHospDr':HospDr}}) //hxy 2019-07-26 LgHospID //hxy 2020-05-25 LgHospID->
}
//双击编辑
function onDbClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

//单击显示左侧
function onClickRow(index,row){
	var row = $('#datagrid').datagrid('getSelected');
	if(!row){
		return;	
	}
	$('#RowId').val(row.ID);
	$('#code').val(row.GHUCode);
	$('#desc').val(row.GHUDesc);
	$('#date').datetimebox('setValue',row.GHUDateAndTime);
	$('#Aboutspec').val(row.GHUGeneralSpec);
	$('#detailspec').val(row.GHUDetailSpec);
	$('#Active').combobox('setValue',row.GHUActiveFlag);
	//$('#hospital').combobox('setValue',row.GHUHospDrID); //hxy 2020-05-25 注释
	$('#hopid').val(row.GHUHospDrID);
}


function submitForm(){
	 var params=getparams();
	 $('#formMes').form('submit', { 
        url: "dhcapp.broker.csp?ClassName=web.DHCEMPatGroupHurt&MethodName=SavePatGroupHurt&params="+params, 
        onSubmit: function () {        //表单提交前的回调函数 
          var isValid = $(this).form('validate');//验证表单中的一些控件的值是否填写正确，比如某些文本框中的内容必须是数字 
          if (!isValid) { 
          } 
          return isValid; // 如果验证不通过，返回false终止表单提交 
        }, 
        success: function (data) {  //表单提交成功后的回调函数，里面参数data是方法的返回值。 
          if (data == 0) { 
           	$.messager.alert("提示","保存成功!");
            $('#datagrid').datagrid('reload');  // 重新载入当前页面数据 
            clearForm(); 
          }else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
		  }else{	
				$.messager.alert('提示','保存失败:'+data)
				clearForm();
		  }
        } 
      });  
}

function getparams(){
	var RowId=$('#RowId').val();
	var	code=$('#code').val();
	var	desc=$('#desc').val();
	var	date=$('#date').datetimebox('getValue');
	var	Aboutspec=$('#Aboutspec').val();
	var	detailspec=$('#detailspec').val();
	var active=$('#Active').combobox('getValue');
	//var hosp=$('#hospital').combobox('getValue'); //hxy 2020-05-25 注释
	var hosp=hospComp.getValue(); //hxy 2020-05-25 
	var hopid=""
	return encodeURIComponent(code)+"^"+encodeURIComponent(desc)+"^"+date+"^"+encodeURIComponent(Aboutspec)+"^"+encodeURIComponent(detailspec)+"^"+active+"^"+hosp+"^"+hopid+"^"+RowId;
}

function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCEMPatGroupHurt","RemoveGroupHurt",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

/// form清除
function clearForm(){
	$('#formMes').form("clear");
	var Activedata = $('#Active').combobox('getData');
	if(Activedata.length>0){
		$('#Active').combobox('select',Activedata[0].value);	
	}
 	/*var Hopdata = $('#hospital').combobox('getData');
 	if(Hopdata.length>0){
		$('#hospital').combobox('select',Hopdata[0].value);	
	}*/ //hxy 2020-05-25 注释
}

function query(){
	$("#GHUHospDrID").val(hospComp.getValue());
	commonQuery({'datagrid':'#datagrid','formid':'#toolbar'}); //调用查询
}
function queryReset(){
	$("#GHUCode").val("");
	$("#GHUDesc").val("");
	query();
}




///CreatDate:  2018-07-06
///Author:     zhouxin 
$(function(){
	 hospComp = GenHospComp("DHC_EmGuaLevel");  //hxy 2020-05-25 st
	 hospComp.options().onSelect = function(){///选中事件
	 	query();
	 }
     query();//ed

	 $('#addBTN').on('click',function(){
		 var HospDr=hospComp.getValue(); //hxy 2020-05-25
		 commonAddRow({'datagrid':'#datagrid',value:{'GLEActiveFlag':'Y','GLEHospDesc':HospDr}}) //hxy 2020-05-25 LgHospID->HospDr
	 })
	 $('#saveBTN').on('click',function(){
		 saveByDataGrid("web.DHCEMDocGuaLevel","save","#datagrid");
	 })
	 $('#queryBTN').on('click',function(){
		 commonQuery({'datagrid':'#datagrid','formid':'#toolbar'}); //调用查询
	 })
	 $('#removeBTN').on('click',function(){
		 commonRemove("web.DHCEMDocGuaLevel","remove","#datagrid"); 
	 })  
	//同时给代码和描述绑定回车事件
     $('#GUACode,#GUADesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#toolbar'}); //调用查询
        }
    });
    /*$('#hospDrID').combobox({ //hxy 2019-07-20 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) //hxy ed*/ //hxy 2020-05-24 注释
	
});

function query(){
	$("#hospDrID").val(hospComp.getValue());
	commonQuery({'datagrid':'#datagrid','formid':'#toolbar'}); //调用查询
}


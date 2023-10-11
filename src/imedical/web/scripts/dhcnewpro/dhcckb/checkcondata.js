var editRow=0;
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)

$(function(){ 

		initCombobox();
		initButton();
		initCheckList();
		
})

///初始化combobox
function initCombobox()
{
				var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
		  $HUI.combobox("#hosp",{
						 		url:uniturl,
									valueField:'value',
									textField:'text',
									panelHeight:"160",
									mode:'remote',
									onSelect:function(ret){
															query();
								 }
		 	})
		 	
		 	var uniturl = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
		
	 		$HUI.combobox("#diction",{
						 		url:uniturl,
									valueField:'value',
									textField:'text',
									panelHeight:"160",
									mode:'remote',
									onSelect:function(ret){
															query();
								 }
		 	})
}

///初始化按钮
function initButton()
{
		$("#find").bind("click",query);
		$("#reset").bind("click",reset);
}
///药品列表
function initCheckList(){
							var columns=[[
				        {field:'libDesc',title:'知识库药品名称',width:420},
				        {field:'hisDesc',title:'项目药品名称',width:320},
				        
							]];
							var params = $HUI.combobox("#hosp").getValue() +"^"+ $HUI.combobox("#diction").getValue();

							///  定义datagrid  
							var option = {
															nowrap:false,
															rownumbers : true,
															singleSelect : true
								};
							var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryLibMatchHis&params="+params; 
							new ListComponent('druginfodg', columns, uniturl, option).Init();
}

//选中项目药品名称查询
function initproList(){
		var columns=[[
		          {field:'hisDesc',title:'项目药品名称',width:420},
				        {field:'libDesc',title:'知识库药品名称',width:320},
				        
							]];
							var params = $HUI.combobox("#hosp").getValue() +"^"+ $HUI.combobox("#diction").getValue();

							///  定义datagrid  
							var option = {
															nowrap:false,
															rownumbers : true,
															singleSelect : true
								};
							var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryProMatchHis&params="+params; 
							new ListComponent('druginfodg', columns, uniturl, option).Init();
}


///查询
function query()
{
	  var check="0";
			if($("#prodrug").get(0).checked) {
				var check="1"
   }else{
	   var check="0"
   }
   if(check==0){
	    initCheckList();
   }else{
	    initproList();
   }
}

///重置
function reset()
{
			$HUI.combobox("#hosp").setValue("") ;
			$HUI.combobox("#diction").setValue(""); 
			$HUI.checkbox('#prodrug').uncheck();
			query();
}
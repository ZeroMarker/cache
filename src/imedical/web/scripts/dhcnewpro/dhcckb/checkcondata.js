var editRow=0;
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "DictionFlag" 	// �ֵ���(��������ֵ)

$(function(){ 

		initCombobox();
		initButton();
		initCheckList();
		
})

///��ʼ��combobox
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

///��ʼ����ť
function initButton()
{
		$("#find").bind("click",query);
		$("#reset").bind("click",reset);
}
///ҩƷ�б�
function initCheckList(){
							var columns=[[
				        {field:'libDesc',title:'֪ʶ��ҩƷ����',width:420},
				        {field:'hisDesc',title:'��ĿҩƷ����',width:320},
				        
							]];
							var params = $HUI.combobox("#hosp").getValue() +"^"+ $HUI.combobox("#diction").getValue();

							///  ����datagrid  
							var option = {
															nowrap:false,
															rownumbers : true,
															singleSelect : true
								};
							var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryLibMatchHis&params="+params; 
							new ListComponent('druginfodg', columns, uniturl, option).Init();
}

//ѡ����ĿҩƷ���Ʋ�ѯ
function initproList(){
		var columns=[[
		          {field:'hisDesc',title:'��ĿҩƷ����',width:420},
				        {field:'libDesc',title:'֪ʶ��ҩƷ����',width:320},
				        
							]];
							var params = $HUI.combobox("#hosp").getValue() +"^"+ $HUI.combobox("#diction").getValue();

							///  ����datagrid  
							var option = {
															nowrap:false,
															rownumbers : true,
															singleSelect : true
								};
							var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryProMatchHis&params="+params; 
							new ListComponent('druginfodg', columns, uniturl, option).Init();
}


///��ѯ
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

///����
function reset()
{
			$HUI.combobox("#hosp").setValue("") ;
			$HUI.combobox("#diction").setValue(""); 
			$HUI.checkbox('#prodrug').uncheck();
			query();
}
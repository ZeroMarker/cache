/**综合查询工具**/
$(function(){ 
	initcombobox();									//初始化下拉框
})

///初始化下拉框
function initcombobox()
{
		$('#modelTree').combotree({
	    	url:$URL+'?ClassName=web.DHCCKBComQuery&MethodName=QueryTreeList',
	    	lines:true,
			animate:true,
			onSelect: function(rec){
				runClassMethod("web.DHCCKBRuleIndex","ListModelDataGrid",{"parent":rec.value},function(data){
								var json = eval('(' + data + ')');
								var columns = [json];
								var option = {	
									rownumbers : true,
									singleSelect : true
								};
							var params = getParams();	
							alert(params)
							var uniturl = $URL+"?ClassName=web.DHCCKBComQuery&MethodName=ListModelData&parent="+rec.value+"&params="+params;
							new ListComponent('dataList', columns, uniturl, option).Init();
				},'text'); 
			}
		});	
		
		///药品
	
		var uniturl = $URL+"?ClassName=web.DHCCKBComQuery&MethodName=QueryDrugList"  
		$HUI.combobox('#drug',{
			url:uniturl,
			valueField:'value',
			textField:'text',
			panelHeight:"220",
			mode:'remote',
			onSelect:function(ret){
				var params = getParams();	
			}
		});
		
		///厂家
	
		var uniturl = $URL+"?ClassName=web.DHCCKBComQuery&MethodName=QueryManufactList"  
		$HUI.combobox('#manufact',{
			url:uniturl,
			valueField:'value',
			textField:'text',
			panelHeight:"220",
			mode:'remote',
			onSelect:function(ret){
				var params = getParams();	
			}
		});
		///剂型
	
		var uniturl = $URL+"?ClassName=web.DHCCKBComQuery&MethodName=QueryDosformList"  
		$HUI.combobox('#dosform',{
			url:uniturl,
			valueField:'value',
			textField:'text',
			panelHeight:"220",
			mode:'remote',
			onSelect:function(ret){
				var params = getParams();	
			}
		});
}
function getParams()
{
	var drugDesc = $HUI.combobox("#drug").getText();
	var manufactor = $HUI.combobox("#manufact").getText();
	var doseform = $HUI.combobox("#dosform").getText();
	return drugDesc +"^"+ manufactor +"^"+ doseform;
}
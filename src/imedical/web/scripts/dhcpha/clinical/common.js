function addPatMedAdvPanel(i,medAdvID)
{
	var htmlstr = '<div id="rf_'+medAdvID+'" class="btn-ui-div" style="width:1010px;margin_top:10px; border:1px solid #E7E7E7;border-radius:4px;">';
	var htmlstr = htmlstr + '<div style="margin:10px 0px;">';
	var htmlstr = htmlstr + '  <label class="btn-ui-div" style="font-weight:bold;">ҽ���б�</label>';
	var htmlstr = htmlstr + '  <div  style="margin:10px" class="sssss">';
	var htmlstr = htmlstr + '      <table class="hisui-datagrid" style="width:990px" id="dg'+medAdvID+'"></table>';
	var htmlstr = htmlstr + '  </div>';
	var htmlstr = htmlstr + '	</div>';
	
	//��������
    /* var htmlstr = htmlstr + '      <div class="dashline-div"></div>'; */
			        
	////<!--����-->
	var htmlstr = htmlstr + '<div>';
	var htmlstr = htmlstr + '	<div style="margin-top:-10px">';
	var htmlstr = htmlstr + '		<div  style="height:30px;line-height:30px"><span style="font-weight:bold;margin-left:10px;">��ҩ���飺</span></div>';
	var htmlstr = htmlstr + '		<div style="margin-top:-10px;" id="medA_'+medAdvID+'"></div>';
	var htmlstr = htmlstr + '   </div>';
	var htmlstr = htmlstr + '</div>';
	////<!--����-->
	var htmlstr = htmlstr + '<div style="margin:5px 10px 10px 10px">';
	var htmlstr = htmlstr + '	<textarea id="textarea_'+medAdvID+'" style="width:990px;height:80px;border:1px solid #E7E7E7;font-family:Microsoft YaHei;">�����뷴������...</textarea>';
		////<!--button-->
	var htmlstr = htmlstr + '   <div class="btn-ui-btn btn-ui-div" style="margin-top:10px;text-align:right;">';
	var htmlstr = htmlstr + '	<span class="btn-ui">';
	var htmlstr = htmlstr + '		<button href="#" class="yanshi1 btn-default" id="btns_'+medAdvID+'">����</button>';
	var htmlstr = htmlstr + '		<button href="#" class="yanshi btn-default" id="btnr_'+medAdvID+'">����</button>';
	var htmlstr = htmlstr + '	</span>';
	var htmlstr = htmlstr + '   </div>';
	var htmlstr = htmlstr + '</div>';
/* 	$HUI.panel("#Num",{
		title:"���",
		headerCls:'panel-header-gray'
		}); */
		
	$('#r_list').append(htmlstr);
	
}
if ($.messager){
	$.messager.defaults.ok = 'ȷ��';
	$.messager.defaults.cancel = 'ȡ��';
}


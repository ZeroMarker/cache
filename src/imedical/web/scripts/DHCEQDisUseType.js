jQuery(document).ready
(
	function()
	{
		jQuery("#BSubmit").linkbutton({iconCls: 'icon-search'});
		jQuery("#BSubmit").on("click", BSubmit_Clicked);
	}

);
function BSubmit_Clicked()
{
	if (jQuery("#DisuseType").combobox("getValue")=="")
	{
		alertShow("��ѡ�񱨷����ͣ�")
		return;
	}
	var BatchRequestFlag=jQuery("#DisuseType").combobox("getValue")
	parent.opener.BatchDisuse(BatchRequestFlag)
	
	
}
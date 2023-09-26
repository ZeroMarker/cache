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
		alertShow("请选择报废类型！")
		return;
	}
	var BatchRequestFlag=jQuery("#DisuseType").combobox("getValue")
	parent.opener.BatchDisuse(BatchRequestFlag)
	
	
}
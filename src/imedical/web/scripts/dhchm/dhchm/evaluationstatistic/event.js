
function InitViewportMainEvent(obj)
{	obj.LoadEvent = function(args)
	{
	}
	obj.ButtonES_click = function()
	{
		if (obj.ComboBoxHCI.getValue()==""){
			ExtTool.alert("��ʾ","��Ա���಻��Ϊ��");
			return;
		}
		obj.GridPanelESStore.load({params: {
                	start: 0,
                	limit: 25
            	}});
	};
	obj.ComboBoxHC_select = function()
	{
		obj.ComboBoxHCI.setValue();
		obj.ComboBoxHCIStore.load({});
	};
/*ViewportMain��������ռλ��*/

































































































}

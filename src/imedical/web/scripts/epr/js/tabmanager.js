var _CurrentCharttype = "";

//Tab显示相应的页面内容(无需指定 charttype)
function showGeneralTab(openurl, tabpageflag){
	showTab(_CurrentCharttype, openurl, tabpageflag);
}

//Tab显示相应的页面内容,并控制页签的显示
function showTab(newcharttype, openurl, tabpageflag){
	var isNeedEprlist = false, isNeedEpredit = false, hasActiveTab = false;
	var eprlistIndex = 0, epreditIndex = 0;

	if (tabpageflag == 'epredit' || tabpageflag == 'eprlist')
	{
		if (newcharttype == 'single')
		{
			isNeedEprlist = false; isNeedEpredit = true;
		}
		else if (newcharttype == 'multiple')
		{
			isNeedEprlist = true;
			isNeedEpredit = (tabpageflag == 'epredit');
		}

		eprlistIndex = getTabpageIndex(tabpannel, 'eprlist');
		epreditIndex = getTabpageIndex(tabpannel, 'epredit');
		if (!isNeedEprlist && eprlistIndex > -1){tabpannel.remove('eprlist');}
		if (!isNeedEpredit && epreditIndex > -1){tabpannel.remove('epredit');}

		if (isNeedEprlist && eprlistIndex < 0){eprlistIndex = tabpannel.add(Ext.getCmp('eprlist'));tabpannel.setActiveTab(eprlistIndex); hasActiveTab = true;}
		if (isNeedEpredit && epreditIndex < 0){epreditIndex = tabpannel.add(Ext.getCmp('epredit'));tabpannel.setActiveTab(epreditIndex); hasActiveTab = true;}
	}

	Ext.getDom("frame" + tabpageflag).src = openurl;
	
	if (!hasActiveTab)
	{
		var activeTabIndex = getTabpageIndex(tabpannel, tabpageflag);
		
		if (activeTabIndex > -1 && activeTabIndex < tabpannel.items.items.length){tabpannel.setActiveTab(activeTabIndex);}
	}

	//Ext.getCmp("southregion").collapse(true);
	_CurrentCharttype = newcharttype;
}

//获取某一页签的索引号（返回值为-1时表示没有该页签）
function getTabpageIndex(tab, tagpageid)
{
	var tabpageIndex = -1;

	for (var curIndex = 0; curIndex < tab.items.length; curIndex++)
	{
		var curPage = tab.items.items[curIndex];
		if (curPage.id && curPage.id == tagpageid)
		{
			tabpageIndex = curIndex;
			break; 
		}
	}

	return tabpageIndex;
}
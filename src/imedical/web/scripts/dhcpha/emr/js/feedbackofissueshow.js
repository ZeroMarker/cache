function changeP(){
	var dg = $('#dg');
	dg.datagrid('loadData',[]);
	dg.datagrid('bottom');
	dg.datagrid('getPager').pagination({
		layout:['list','sep','first','prev','sep','manual','sep','next','last','sep','refresh']
	});
}

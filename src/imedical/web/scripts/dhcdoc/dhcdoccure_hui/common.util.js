function pagerFilter(data){
	if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
		data = {
			total: data.length,
			rows: data
		}
	}
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	//debugger;
	pager.pagination({
		showRefresh:false,
		onSelectPage:function(pageNum, pageSize){
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh',{
				pageNumber:pageNum,
				pageSize:pageSize
			});
			dg.datagrid('loadData',data);
			dg.datagrid('scrollTo',0); //滚动到指定的行  
			_selectItemRow=undefined;
			dg.parent().find("div .datagrid-header-check")
                .children("input[type=\"checkbox\"]").eq(0)
                .attr("checked", false);  
		}
	});
	if (!data.originalRows){
		data.originalRows = (data.rows);
	}
	if (data.total>0) {
		var start = (opts.pageNumber==0?1:opts.pageNumber-1)*parseInt(opts.pageSize);
		if ((start+1)>data.originalRows.length){
			//取现有行数最近的整页起始值
			start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
			opts.pageNumber=(start/opts.pageSize)+1; //1;
		}
		var end = start + parseInt(opts.pageSize);
		data.rows = (data.originalRows.slice(start, end));
	}
	return data;
}
function Util_InitHospList(code)
{
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp(code,hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}

function Util_GetSelHospID(){
	var HospID="";
	if($('#_HospList').length>0){
		HospID=$HUI.combogrid('#_HospList').getValue();
	}
	else if($('#_HospUserList').length>0){
		HospID=$HUI.combogrid('#_HospUserList').getValue();
	}
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	return HospID;
}
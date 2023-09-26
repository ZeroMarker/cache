$(function()
{
	if ('getAllLog'==action) {
		var getdata_url = '../EMRservice.Ajax.logdetailrecord.cls?Action=getAllLog&EpisodeID=' + episodeId;
	}
	else {
		var getdata_url = '../EMRservice.Ajax.logdetailrecord.cls?Action=getDetialLog&EpisodeID=' + episodeId + '&EMRDocID=' + emrDocId + '&EMRNum=' + emrNum;
	}
	showLogDetail(getdata_url);
	
});
///日志操作记录明细
function showLogDetail(getdata_url)
{
	$("#detailGrid").datagrid({
		loadMsg:'数据装载中......',
		fit:true,
		headerCls:'panel-header-gray',
		url:getdata_url,
		singleSelect:true,
		idField:'OrderID',
		columns:[[
			{field:'OrderID',title:'顺序号',width:60,sortable:true,type:'int'},
			{field:'LoginUserName',title:'登录医师',width:80,sortable:true},
			{field:'OperUserName',title:'操作医师',width:80,sortable:true},
			{field:'OperDate',title:'操作日期',width:100,sortable:true},
			{field:'OperTime',title:'操作时间',width:90,sortable:true},
			{field:'MachineIP',title:'IP地址',width:100,sortable:true},
			{field:'Action',title:'操作名称',width:90,sortable:true,
				formatter: function(value,row,index){
					if(row.CASignID != ""){
						return "<a href='#' style='text-decoration:none;color:blue;' onclick='openSignDetail("+row.CASignID+")'>"+value+"</a>"
					}else{
						return value	
					}
				}
			},
			{field:'TplName',title:'模板名称',width:100,sortable:true,resizable: true},
			{field:'TplCreateDate',title:'创建日期',width:100,sortable:true},
			{field:'TplCreateTime',title:'创建时间',width:90,sortable:true},
			{field:'ProductSource',title:'产品模块',width:75,sortable:true}
		]]
	});
}
function openSignDetail(signID){
//	var result=window.showModalDialog('emr.signDetail.csp?SignID='+signID, window, 'dialogHeight:500px;dialogWidth:600px;resizable:no;status:no');
	var tempFrame = '<iframe id="iframeSignDetail" scrolling="auto" frameborder="0" src="emr.signDetail.csp?SignID='+signID+'" style="width:100%;height:100%;display:block;"></iframe>';
	parent.createModalDialog("dialogSignDetail","签名信息","520","620","iframeSignDetail",tempFrame,"","");
}

//关闭窗口
function closeWindow() {
	closeDialog("dialogInstanceLog");
    
}
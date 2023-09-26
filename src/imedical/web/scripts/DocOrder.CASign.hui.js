var PageLogicObj={
	m_CASignOrdListDataGrid:""
};
$(function(){
	//页面数据初始化
	Init();
	//加载待签名医嘱列表
	CASignOrdListDataGridLoad();
});
function SaveCASignList(){
	try{
		debugger
		var ContainerName="";
		var caIsPass=0;
		if (ServerObj.CAInit==1) 
		{  
			//判断当前key是否是登陆时候的key
		    var rtn=dhcsys_getcacert();
		    if (rtn.IsSucc){
				if (rtn.ContainerName==""){
					ContainerName="";
		    		caIsPass=0;
				}else{
					ContainerName=rtn.ContainerName;
		    		caIsPass=1;
				}
			}else {
				ContainerName="";
		    	caIsPass=0;
				$.messager.alert("提示","签名失败");
		        return false;
			}
		}else{
			//$.messager.alert("提示","CA未启用,无法签名。");
		    //return false;
		}
		
		var OperationTypList="";
		var OrderId="";
		var OperationTyp="";
		debugger
		var win = $.messager.progress({
			title:'Please waiting',
			msg:'Loading data...',
			interval:''
		});
		

		var bar=win.find("div.messager-p-bar")
		
		var ListData = PageLogicObj.m_CASignOrdListDataGrid.datagrid('getData');
		
		for (var i=0;i<ListData.originalRows.length;i++){
			OrderId=ListData.originalRows[i].OrderId;
			OperationTypList=ListData.originalRows[i].OperationTypList;
			for (var j=0;j<OperationTypList.length;j++){
				OperationTyp=OperationTypList.slice(j,j+1);
				//console.log(OrderId+"||"+OperationTyp);
				//SaveCASign(ContainerName,OrderId,OperationTyp);
			}
			bar.progressbar("setValue", i);
		}
		$.messager.progress('close');
	}catch(E){
		$.messager.alert("提示",E.message);
		return;
	}
}

function SaveCASign(ContainerName,OrdList,OperationType) 
{    
	try{
      if (ContainerName=="") return false;
      //1.批量认证
	    var CASignOrdStr="";
	    var TempIDs=OrdList.split("^");
		var IDsLen=TempIDs.length;
		for (var k=0;k<IDsLen;k++) {
			var TempNewOrdDR=TempIDs[k].split("&");
			if (TempNewOrdDR.length <=0) continue;
			var newOrdIdDR=TempNewOrdDR[0];
			if (newOrdIdDR.indexOf("!")>0){
				newOrdIdDR=newOrdIdDR.split("!")[0];
			}
			
			if(CASignOrdStr=="")CASignOrdStr=newOrdIdDR;
			else CASignOrdStr=CASignOrdStr+"^"+newOrdIdDR;			
		}
		var SignOrdHashStr="",SignedOrdStr="",CASignOrdValStr="";
		var CASignOrdArr=CASignOrdStr.split("^");
		for (var count=0;count<CASignOrdArr.length;count++) {
			var CASignOrdId=CASignOrdArr[count];
			var OEORIItemXML=cspRunServerMethod(ServerObj.GetOEORIItemXMLMethod,CASignOrdId,OperationType);
			var OEORIItemXMLArr=OEORIItemXML.split(String.fromCharCode(2));
			for (var ordcount=0;ordcount<OEORIItemXMLArr.length;ordcount++) {
				if (OEORIItemXMLArr[ordcount]=="")continue;
  				var OEORIItemXML=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[1];
   				var OEORIOperationType=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[0];
				//$.messager.alert("警告","OEORIItemXML:"+OEORIItemXML);
				var OEORIItemXMLHash=HashData(OEORIItemXML);
				//$.messager.alert("警告","HashOEORIItemXML:"+OEORIItemXMLHash);
				if(SignOrdHashStr=="") SignOrdHashStr=OEORIItemXMLHash;
				else SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&"+OEORIItemXMLHash;
				//$.messager.alert("警告",ContainerName);
				var SignedData=SignedOrdData(OEORIItemXMLHash,ContainerName);
				if(SignedOrdStr=="") SignedOrdStr=SignedData;
				else SignedOrdStr=SignedOrdStr+"&&&&&&&&&&"+SignedData;
				if(CASignOrdValStr=="") CASignOrdValStr=OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
				else CASignOrdValStr=CASignOrdValStr+"^"+OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
			}
		}
		if (SignOrdHashStr!="")SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&";
		if (SignedOrdStr!="")SignedOrdStr=SignedOrdStr+"&&&&&&&&&&";
		//获取客户端证书
    	var varCert = GetSignCert(ContainerName);
    	var varCertCode=GetUniqueID(varCert);
		/*
		alert("CASignOrdStr:"+CASignOrdStr);
		alert("SignOrdHashStr:"+SignOrdHashStr);
		alert("varCert:"+varCert);
		alert("SignedData:"+SignedOrdStr);
		*/
    	if ((CASignOrdValStr!="")&&(SignOrdHashStr!="")&&(varCert!="")&&(SignedOrdStr!="")){
			//3.保存签名信息记录																												CASignOrdValStr,session['LOGON.USERID'],"A",					SignOrdHashStr,varCertCode,SignedOrdStr,""
			var ret=cspRunServerMethod(ServerObj.InsertCASignInfoMethod,CASignOrdValStr,session['LOGON.USERID'],OperationType,SignOrdHashStr,varCertCode,SignedOrdStr,"");
			if (ret!="0") {
				alert("数字签名没成功");
				return false;
			}else{
				alert("CA sucess")
			}
		}else{
	  		alert("数字签名错误");
	  		return false;
		} 
		return true;
	}catch(e){alert("CA err:"+e.message);return false;}
}


function Init(){
	PageLogicObj.m_CASignOrdListDataGrid=InitCASignOrdListDataGrid();
}
function InitCASignOrdListDataGrid(){
    /*OrderId:%String,StDate:%String,Doctor:%String,StopDate:%String,StopDoctor:%String,
    ItemStatDesc:%String,OrderDesc:%String,OperationTypList:%String*/
	var Columns=[[
		{field:'OrderId',hidden:true},
		{field:'StDate',title:'医嘱开始时间',width:100,align:'center'},
		{field:'ItemStatDesc',title:'医嘱状态',width:100,align:'center'},
		{field:'OrderDesc',title:'医嘱名称',width:240,align:'center'},
		{field:'Doctor',title:'下医嘱医生',width:100,align:'center'},
		{field:'StopDate',title:'停止时间',width:100,align:'center'},
		{field:'StopDoctor',title:'停医嘱医生',width:100,align:'center'},
		{field:'OperationTypList',title:'操作类型',hidden:true}
    ]];
    var toolbar=[{
		text: '签名',
		iconCls: 'icon-exe-order',
		handler: function() {
			SaveCASignList();
		}
	}];
	var CASignOrdListDataGrid=$("#CASignOrdList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'OrderId',
		toolbar:toolbar,
		columns :Columns
	}); 
	return CASignOrdListDataGrid;
}
function CASignOrdListDataGridLoad(){
	$.q({
	    ClassName : "web.DHCDocSignVerify",
	    QueryName : "FindNeedCASignOrder",
	    EpisodeID:ServerObj.EpisodeID,
	    UserID:session['LOGON.USERID'],
	    ViewAll:ServerObj.ViewAll,
	    Pagerows:PageLogicObj.m_CASignOrdListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_CASignOrdListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
	}); 
}

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
		}
	});
	if (!data.originalRows){
		data.originalRows = (data.rows);
	}
	var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
	if ((start+1)>data.originalRows.length){
		//取现有行数最近的整页起始值
		start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
		opts.pageNumber=opts.pageNumber-1;
	}
	var end = start + parseInt(opts.pageSize);
	data.rows = (data.originalRows.slice(start, end));
	return data;
}
//icare.BDReqForm
var init = function (){
	$("#ticare_BDReqForm").datagrid('options').onClickCell = function(index,field,value){
		if (field=="ItmName"){
			var row = $("#ticare_BDReqForm").datagrid('getSelected')
			websys_showModal({
				url:'dhc.orderview.csp?ord='+row["OrdItemId"],
				title:'医嘱闭环',
				width:1200,height:300,top:20,left:100
			})
		}
	}
}
//$(init);
websys_lu_bak = websys_lu;
websys_lu = function(url,flag,opt){
	if (url.indexOf("ord=")>-1){
		websys_showModal({
			url: url, //'dhc.orderview.csp?ord='+row["OrdItemId"],
			title: '医嘱闭环',
			width: 900,height:250,top:20,left:100
		})
	}else{
		websys_lu_bak(url,flag,opt);
	}
}
///qqa
///2017-12-19
$(function(){
	
	runClassMethod("web.DHCAPPSeePatLisHist","JsonGetLisHis",{OEORIID:OEORIID},
	   function(data){
			if(data!=""){
				initDatagrid(data);
			}
	   },"text",false
	);	
})

function stylerVal(value, row, index){
	var colStyle="color:black";
    if (value.indexOf("#")!=-1) {
        if (value.split("#")[1] == "L") { colStyle = "color:blue"};
		if (value.split("#")[1] == "H") { colStyle = "color:red"};
		if (value.split("#")[1] == "PL") { colStyle = "background-color:red;color:blue" };
		if (value.split("#")[1] == "PH") { colStyle = "background-color:red;color:#ffee00" };
		if (value.split("#")[1] == "UL") { colStyle = "background-color:red;color:blue"};
		if (value.split("#")[1] == "UH") { colStyle = "background-color:red;color:#ffee00"};                 
    }
    return colStyle;	
}

function formVal(value){
	
	return value.split("#")[0];	
}

function initDatagrid(Params){

	var columNum = Params.split("^")[1];
	var colArray=[],dymObj={};

	for(i=1;i<=columNum;i++){
		dymObj={};
		dymObj.field="field"+i;
		dymObj.align="center";
		if(i==1){
			dymObj.title="项目";	
		}else{
			dymObj.title="值"+(i-1);
			dymObj.styler= stylerVal;
			dymObj.formatter= formVal;	
		}
		colArray.push(dymObj);
	}
	
	var columns=[];
	columns.push(colArray);

	$HUI.datagrid("#patLisHistTable",{
		url:LINK_CSP+"?ClassName=web.DHCAPPSeePatLisHist&MethodName=GetDataGrid&Params="+Params,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  
		pageList:[10], 
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		showHeader:true,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
		
		},
		onDblClickRow:function(rowIndex,rowData){
		
		}
	})	
}

